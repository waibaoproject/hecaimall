//
//  ProductBriefCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/27.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class ProductBriefCell: UITableViewCell, Reusable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var expressFeeLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    
    var product: Product! {
        didSet {
            nameLabel.text = product.name
            priceLabel.text = product.price.display
            expressFeeLabel.text = "快递：\(product.expressFee.displayYuan)"
            salesLabel.text = "月销\(product.salesCount)笔"
        }
    }
    
    @IBAction func clickShareButton(sender: Any) {
        // TODO: 分享到社交网络
    }
}
