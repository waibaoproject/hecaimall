//
//  OrderNumberCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class OrderNumberCell: UITableViewCell, Reusable {

    @IBOutlet weak var numberLabel: UILabel!
    
    var order: Order! {
        didSet {
            numberLabel.text = "订单号：" + (order.number ?? "")
        }
    }
}
