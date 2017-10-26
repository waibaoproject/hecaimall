//
//  CaculateCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/27.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class CaculateCell: UITableViewCell, NibReusable {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    static let cellHeight: CGFloat = 117
    
    // TODO
    var item: String? {
        didSet {
            productNameLabel.text = ""
            companyLabel.text = ""
            countLabel.text = "共1件"
            totalPaymentLabel.text = "合计：¥612.00"
        }
    }
    
}
