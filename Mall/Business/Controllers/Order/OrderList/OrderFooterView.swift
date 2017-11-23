//
//  OrderFooterView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class OrderFooterView: UICollectionViewCell, NibReusable {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var waitForPayView: UIView!
    @IBOutlet weak var waitForDeliverView: UIView!
    @IBOutlet weak var waitForReceiveView: UIView!
    @IBOutlet weak var waitForCommentView: UIView!
    
    var order: Order! {
        didSet {
            switch order.state {
            case .waitForPay:
                waitForPayView.isHidden = false
                waitForDeliverView.isHidden = true
                waitForReceiveView.isHidden = true
                waitForCommentView.isHidden = true
            case .waitForDeliver, .canceled:
                waitForPayView.isHidden = true
                waitForDeliverView.isHidden = false
                waitForReceiveView.isHidden = true
                waitForCommentView.isHidden = true
            case .waitForReceive:
                waitForPayView.isHidden = true
                waitForDeliverView.isHidden = true
                waitForReceiveView.isHidden = false
                waitForCommentView.isHidden = true
            case .end:
                waitForPayView.isHidden = true
                waitForDeliverView.isHidden = true
                waitForReceiveView.isHidden = true
                waitForCommentView.isHidden = false
      
            }
            descLabel.text = "共\(order.items.count)件商品 合计：\(order.totalPayment.display) (含运费\(order.expressFee.display)"
        }
    }
    
    var didClickCancelOrder: ((Order) -> Void)?
    var didClickPayOrder: ((Order) -> Void)?
    var didClickReceive: ((Order) -> Void)?

    @IBAction func clickDeliverInfoButton(sender: Any) {
        let controller = WebViewController()
        controller.url = order.deliveryProgressUrl
        parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickContactButton(sender: Any) {
        let controller = CustomServiceViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickCancelButton(sender: Any) {
        didClickCancelOrder?(order)
    }
    
    @IBAction func clickPayButton(sender: Any) {
        didClickPayOrder?(order)
    }
    
    @IBAction func clickReceiveButton(sender: Any) {
        didClickReceive?(order)
    }
}
