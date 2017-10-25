//
//  OrderProductItemCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import WebImage

class OrderProductItemCell: UITableViewCell, Reusable {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!

    var productItem: ProductItem! {
        
        didSet {
            coverImageView.web.setImage(with: productItem.product.cover)
            nameLabel.text = productItem.product.name
            priceLabel.text = productItem.product.price.display
            typeLabel.text = "类型：" + (productItem.product.type ?? "")
            countLabel.text = "X\(productItem.count)"
            countTextField.text = "\(productItem.count)"
        }
    }
    
    var didClickAdd: ((ProductItem) -> Void)?
    var didClickReduce: ((ProductItem) -> Void)?
    
    @IBAction func clickAddButton(sender: Any) {
        didClickAdd?(productItem)
    }
    
    @IBAction func clickReduceButton(sender: Any) {
        didClickReduce?(productItem)
    }
}

