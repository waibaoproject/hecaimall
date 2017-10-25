//
//  ProductViewedCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/5.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import Reusable

class ProductViewedCell: UITableViewCell, NibReusable {
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var left: NSLayoutConstraint!
    
    var product: Product? {
        didSet {
            coverImageView.web.setImage(with: product?.cover)
            nameLabel.text = product?.name
            typeLabel.text = "类型: \(product?.type ?? "")"
            priceLabel.text = product?.price.display
            salesLabel.text = "月销\(product?.salesCount ?? 0)笔"
        }
    }
    
    var isEditMode: Bool = false {
        didSet {
            if isEditMode {
                left.constant = 70
            } else {
                left.constant = 20
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var is_selected: Bool = false {
        didSet {
            selectedButton.isSelected = is_selected
        }
    }
}
