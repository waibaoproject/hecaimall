//
//  CartItemCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import Reusable

class CartItemCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var productItem: ProductItem! {
        didSet {
            selectedButton.isSelected = productItem.isSelected
            coverImageView.web.setImage(with: productItem.product.cover)
            nameLabel.text = productItem.product.name
            typeLabel.text = "类型：\(productItem.product.type ?? "")"
            priceLabel.text = productItem.product.price.display
            countLabel.text = "x\(productItem.count)"
        }
    }
    
    var didClickSelect: ((ProductItem) -> Void)?
    
    @IBAction func clickSelectButton(sender: Any) {
        didClickSelect?(productItem)
    }
}

