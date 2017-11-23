//
//  OrderViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import FoundationExtension
import IQKeyboardManagerSwift

protocol FromOrderStoryboard: StoryboardSceneBased {}

extension FromOrderStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Order", bundle: nil)
    }
}

class OrderViewController: UIViewController, FromOrderStoryboard {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderTotoalItemCountLabel: UILabel!
    @IBOutlet weak var orderTotoalPaymentLabel: UILabel!
    
    var order: Order?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        title = "确认订单"
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }

    
    private func reloadData() {
        orderTotoalItemCountLabel.text = "共\(order?.items.count ?? 0)件，总金额"
        orderTotoalPaymentLabel.text = order?.totalPayment.display
        tableView.reloadData()
    }

    @IBAction func clickPayButton(sender: Any) {
        guard let id = order?.id else {return}
        payForOrder(id: id, in: self, disposeBag: disposeBag, success: { [weak self] in
            guard let `self` = self else {return}
//            jumpToWaitForDelivery(in: self)
            jumpToOrderDetail(orderId: id, in: self)
        }) { [weak self] in
            guard let `self` = self else {return}
//            jumpToWaitForPay(in: self)
            jumpToOrderDetail(orderId: id, in: self)
        }
    }
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if order == nil {
            return 0
        } else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return order!.items.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AddressEditCell
            cell.receiver = order!.receiver
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderNumberCell
            cell.order = order
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderProductItemCell
            cell.productItem = order!.items[indexPath.row]
            cell.didClickAdd = { [weak self] _ in
                guard let `self` = self else {return}
                var order = self.order!
                var item = order.items[indexPath.row]
                item.count += 1
                order.items[indexPath.row] = item
                self.modifyOrder(order)
            }
            cell.didClickReduce = { [weak self] _ in
                guard let `self` = self else {return}
                var order = self.order!
                var item = order.items[indexPath.row]
                guard item.count > 1 else {return}
                item.count -= 1
                order.items[indexPath.row] = item
                self.modifyOrder(order)
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpressWayCell", for: indexPath)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayWayCell", for: indexPath)
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as ExpressFeeCell
            cell.order = order
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderNoteCell
            cell.order = order
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else if indexPath.section == 1 {
            return 40
        } else if indexPath.section == 2 {
            return 130
        }  else if indexPath.section == 3 {
            return 40
        } else if indexPath.section == 4 {
            return 40
        } else if indexPath.section == 5 {
            return 40
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else if section == 1 {
            return .leastNormalMagnitude
        } else if section == 2 {
            return 5
        } else if section == 3 {
            return 5
        } else if section == 4 {
            return 5
        } else if section == 5 {
            return 5
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let controller = AddressManagerViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.didSelectReceiver = { [weak self] in
                guard let `self` = self else {return}
                self.order?.receiver = $0
                self.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            let item = order!.items[indexPath.row]
            let controller = ProductViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.product = item.product
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 3 {
        } else if indexPath.section == 4 {
        } else if indexPath.section == 5 {
        } else {
        }
    }
    
    private func modifyOrder(_ order: Order) {
        let view = LoadingAccessory(view: self.view)
        
        let parameters: [String: Any] = {
            var p: [String: Any] = [:]
            p["receiver_id"] = order.receiver?.id
            for item in order.items {
                p["products[\(item.product.id)]"] = item.count
            }
            p["remark"] = order.remark
            return p
        }()
        let api = APIPath(method: .put, path: "/user/orders/id/\(order.id)", parameters: parameters)
        DefaultDataSource(api: api).response(accessory: view).subscribe(onNext: { [weak self] (order: Order) in
            guard let `self` = self else {return}
            self.order = order
            self.reloadData()
        })
            .disposed(by: disposeBag)
    }
}

func payForOrder(id: String, `in` controller: UIViewController, disposeBag: DisposeBag, success: @escaping () -> Void, failure: @escaping () -> Void) {
    askForPayWay(aliPay: {
        alipay(orderId: id, in: controller, disposeBag: disposeBag, success: success, failure: failure)
    }) {
        wechat1Pay(orderId: id, in: controller, disposeBag: disposeBag, success: success, failure: failure)
    }
}

private func alipay(orderId: String, `in` controller: UIViewController, disposeBag: DisposeBag, success: @escaping () -> Void, failure: @escaping () -> Void) {
    let loading = LoadingAccessory(view: controller.view)
    let api = APIPath(path: "/orders/\(orderId)/payment/alipay")
    DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { (info: AliPayInfo) in
        apiPay(info: info, success: {
            success()
        }, failure: { reson in
            controller.view.toast(reson)
            failure()
        })
    }).disposed(by: disposeBag)
}

private func wechat1Pay(orderId: String, `in` controller: UIViewController, disposeBag: DisposeBag, success: @escaping () -> Void, failure: @escaping () -> Void) {
    let loading = LoadingAccessory(view: controller.view)
    let api = APIPath(path: "/orders/\(orderId)/payment/wechat")
    DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { (info: WechatPayInfo) in
        wechatPay(info: info, success: {
            success()
        }, failure: { reson in
            controller.view.toast(reson)
            failure()
        })
    }).disposed(by: disposeBag)
}

func jumpToOrderDetail(orderId: String, `in` c: UIViewController) {
    let controller = OrderDetailViewController.instantiate()
    controller.orderId = orderId
    controller.hidesBottomBarWhenPushed = true
    c.navigationController?.pushViewController(controller, animated: true)
    
    var controllers = c.navigationController!.viewControllers
    if controllers.count > 2 {
        if controllers[controllers.count - 2] is OrderViewController {
            controllers.remove(at: controllers.count - 2)
            c.navigationController?.viewControllers = controllers
        }
    }
}

//func jumpToWaitForPay(`in` c: UIViewController) {
//    let controller = OrdersIndexViewController.instantiate()
//    controller.hidesBottomBarWhenPushed = true
//    controller.initialIndex = 1
//    c.navigationController?.pushViewController(controller, animated: true)
//    var controllers = c.navigationController!.viewControllers
//    controllers.remove(at: controllers.count - 2)
//    c.navigationController?.viewControllers = controllers
//}
//
//func jumpToWaitForDelivery(`in` c: UIViewController) {
//    let controller = OrdersIndexViewController.instantiate()
//    controller.hidesBottomBarWhenPushed = true
//    controller.initialIndex = 2
//    c.navigationController?.pushViewController(controller, animated: true)
//    var controllers = c.navigationController!.viewControllers
//    controllers.remove(at: controllers.count - 2)
//    c.navigationController?.viewControllers = controllers
//}

