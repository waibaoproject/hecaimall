//
//  ExpressFeeCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class ExpressFeeCell: UITableViewCell, Reusable {

    @IBOutlet weak var feeLabel: UILabel!
    
    var order: Order! {
        didSet {
            feeLabel.text = order.expressFee.display
        }
    }
}
