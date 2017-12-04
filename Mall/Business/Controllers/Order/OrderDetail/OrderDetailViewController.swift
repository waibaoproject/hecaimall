//
//  OrderDetailViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/20.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import Reusable
import RxSwift

class OrderDetailViewController: UIViewController, FromOrderStoryboard, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var waitForPayView: UIView!
    @IBOutlet weak var waitForReceiveView: UIView!
    @IBOutlet weak var waitForCommentView: UIView!
    
    var orderId: String = ""
    
    private let disposeBag = DisposeBag()
    
    
    private var order: Order? {
        didSet {
            if let order = order {
                switch order.state {
                case .waitForPay:
                    waitForPayView.isHidden = false
                    waitForReceiveView.isHidden = true
                    waitForCommentView.isHidden = true
                case .waitForDeliver, .canceled:
                    waitForPayView.isHidden = true
                    waitForReceiveView.isHidden = true
                    waitForCommentView.isHidden = true
                case .waitForReceive:
                    waitForPayView.isHidden = true
                    waitForReceiveView.isHidden = false
                    waitForCommentView.isHidden = true
                case .end:
                    waitForPayView.isHidden = true
                    waitForReceiveView.isHidden = true
                    waitForCommentView.isHidden = false
                    
                }
            } else {
                waitForPayView.isHidden = true
                waitForReceiveView.isHidden = true
                waitForCommentView.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        tableView?.register(cellType: OrderItemTableViewCell.self)
        waitForPayView.isHidden = true
        waitForReceiveView.isHidden = true
        waitForCommentView.isHidden = true
        loadOrder()
    }
    
    private func loadOrder() {
        let api = APIPath(path: "/user/orders/\(orderId)/detail")
        DefaultDataSource(api: api)
            .response(accessory: LoadingAccessory(view: view))
            .subscribe(onNext: {[weak self] (order: Order) in
                guard let `self` = self else {return}
                self.order = order
            })
            .disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if order == nil {
            return 0
        } else {
            return 6 + order!.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lastIndex = 6 + order!.items.count - 1
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderStateCell
            let text: String = {
                switch order!.state {
                case .waitForPay:
                    return "待支付"
                case .waitForDeliver:
                    return "待发货"
                case .waitForReceive:
                    return "待收货"
                case .end:
                    return "已完成"
                case .canceled:
                    return "已取消"
                }
            }()
            cell.label.text = "订单状态：\(text)"
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as AddressEditCell
            cell.receiver = order!.receiver
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderNumberCell
            cell.order = order
            return cell
            
        } else if indexPath.section == lastIndex {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderTimeCell
            let text: String = {
                let createTimeString = order?.createDate?.toString(by: "yyyy-MM-dd HH:mm:ss") ?? ""
                let payTimeString = order?.payDate?.toString(by: "yyyy-MM-dd HH:mm:ss") ?? ""
                let deliverTimeString = order?.deliverDate?.toString(by: "yyyy-MM-dd HH:mm:ss") ?? ""
                switch order!.state {
                case .waitForPay:
                    return "创建时间：\(createTimeString)"
                case .waitForDeliver:
                    return "创建时间：\(createTimeString)\n付款时间：\(payTimeString)"
                case .waitForReceive, .end:
                    return "创建时间：\(createTimeString)\n付款时间：\(payTimeString)\n发货时间：\(deliverTimeString)"
                default:
                    return ""
                }
            }()
            cell.label.text = text
            return cell
            
        } else if indexPath.section == lastIndex - 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
            return cell
            
        } else if indexPath.section == lastIndex - 2 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderSumaryCell
            let count = order!.items.reduce(0, { (result, item) in
                return result + Int(item.count)
            })
            cell.label.text = "共\(count)件商品 合计\(order!.totalPayment.display)(含运费¥0.00)"
            return cell
            
        } else  {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as OrderItemTableViewCell
            let item = order!.items[indexPath.section-3]
            cell.productItem = item
            if order!.state == .end && !item.isCommented {
                cell.commentButton.isHidden = false
            } else {
                cell.commentButton.isHidden = true
            }
            cell.didClickComment = { [weak self] in
                guard let `self` = self else {return}
                let controller = ProductCommentViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.orderId = self.order!.id
                controller.product = $0.product
                controller.didComment = { [weak self] in
                    self?.loadOrder()
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastIndex = 6 + order!.items.count - 1
        
        if indexPath.section == 0 {
            return 35
        } else if indexPath.section == 1 {
            return 80
        } else if indexPath.section == 2 {
            return 35
        } else if indexPath.section == lastIndex {
            return 60
        } else if indexPath.section == lastIndex - 1 {
            return 40
        } else if indexPath.section == lastIndex - 2 {
            return 35
        } else  {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let lastIndex = 6 + order!.items.count - 1
        if section == 0
            || section == 1
            || section == lastIndex - 1
            || section == lastIndex - 2 {
            return 3
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastIndex = 6 + order!.items.count - 1
        if indexPath.section == lastIndex - 1 {
            let controller = CustomServiceViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func clickPayButton(sender: Any) {
        payForOrder(id: orderId, in: self, disposeBag: disposeBag, success: { [weak self] in
            self?.loadOrder()
            }, failure: {
            }, cancel: {
            })
    }
    
    @IBAction func clickShippingButton(sender: Any) {
        let controller = WebViewController()
        controller.url = order?.deliveryProgressUrl
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickReceiveButton(sender: Any) {
        let api = APIPath(method: .put, path: "/user/orders/id/\(orderId)", parameters: ["state": 80])
        DefaultDataSource(api: api)
            .response(accessory: LoadingAccessory(view: view))
            .subscribe(onNext: {[weak self] (order: Order) in
                guard let `self` = self else {return}
                self.order = order
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction  func clickCancelButton(sender: Any) {
        let api = APIPath(method: .put, path: "/user/orders/id/\(orderId)", parameters: ["state": -1])
        DefaultDataSource(api: api)
            .response(accessory: LoadingAccessory(view: view))
            .subscribe(onNext: {[weak self] (order: Order) in
                guard let `self` = self else {return}
                self.order = order
            })
            .disposed(by: disposeBag)
    }
}

