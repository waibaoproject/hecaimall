//
//  OrderHeaderView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class OrderHeaderView: UICollectionViewCell, NibReusable {

    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    var order: Order! {
        didSet {
            orderNumLabel.text = "订单号：\(String(describing: order.number))"
            stateLabel.text = order.state.desc
        }
    }
}
