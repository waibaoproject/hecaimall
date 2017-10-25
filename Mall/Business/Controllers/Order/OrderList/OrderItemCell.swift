//
//  OrderItemCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import Reusable

class OrderItemCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    var didClickComment: ((ProductItem) -> Void)?
    
    var productItem: ProductItem! {
        didSet {
            coverImageView.web.setImage(with: productItem.product.cover)
            nameLabel.text = productItem.product.name
            typeLabel.text = productItem.product.type
            priceLabel.text = productItem.product.price.display
            countLabel.text = "X\(productItem.count)"
        }
    }
    
    @IBAction func clickCommentButton(sender: Any) {
        didClickComment?(productItem)
    }
}
