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
        reloadData()
    }
    
    private func reloadData() {
        orderTotoalItemCountLabel.text = "共\(order?.items.count ?? 0)件，总金额"
        orderTotoalPaymentLabel.text = order?.totalPayment.display
        tableView.reloadData()
    }

    @IBAction func clickPayButton(sender: Any) {
        guard let id = order?.id else {return}
        
        askForPayWay(aliPay: {
            alipay(orderId: id)
        }) {
            // TODO
        }
        
        func alipay(orderId: String) {
            let loading = LoadingAccessory(view: view)
            let api = APIPath(path: "/orders/\(id)/payment/alipay")
            DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { (info: AliPayInfo) in
                apiPay(info: info, success: {
                    
                }, failure: {
                    
                })
            }).disposed(by: disposeBag)
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
