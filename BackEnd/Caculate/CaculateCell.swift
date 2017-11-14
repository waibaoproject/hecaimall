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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var item: ProcurementOrder! {
        didSet {
            productNameLabel.text = item.productName
            companyLabel.text = item.superior
            countLabel.text = "共\(item.count)件"
            totalPaymentLabel.text = "合计：\(item.totalPayment.display)"
        }
    }
}
