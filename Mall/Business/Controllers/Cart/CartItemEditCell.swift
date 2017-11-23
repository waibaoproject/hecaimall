//
//  CartItemEditCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class CartItemEditCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var productItem: ProductItem! {
        didSet {
            selectedButton.isSelected = productItem.isSelected
            coverImageView.web.setImage(with: productItem.product.cover)
            textField.text = "\(productItem.count)"
        }
    }
    
    var didClickAdd: ((ProductItem) -> Void)?
    var didClickReduce: ((ProductItem) -> Void)?
    var didClickDelete: ((ProductItem) -> Void)?
    var didClickSelect: ((ProductItem) -> Void)?
    var didEditCount: ((ProductItem, UInt) -> Void)?
    
    @IBAction func clickSelectButton(sender: Any) {
        didClickSelect?(productItem)
    }
    
    @IBAction func clickAddButton(sender: Any) {
        didClickAdd?(productItem)
    }
    
    @IBAction func clickReduceButton(sender: Any) {
        didClickReduce?(productItem)
    }

    @IBAction func clickDeleteButton(sender: Any) {
        didClickDelete?(productItem)
    }
    
    @IBAction func edittingChanged(sender: Any) {
        guard let count = textField.text?.uintValue else {
            return
        }
        let itemCount = max(1, count)
        textField.text = "\(itemCount)"
        didEditCount?(productItem, itemCount)
    }
}

