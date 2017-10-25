//
//  RecommandProductCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class RecommandProductCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    
    var product: Product? {
        didSet {
            coverImageView.web.setImage(with: product?.cover)
            nameLabel.text = product?.name
            typeLabel.text = ["类型: ", product?.type].flatMap { $0 }.joined()
            priceLabel.text = product?.price.display
            salesLabel.text = "月销\(product?.salesCount ?? 0)笔"
        }
    }
    
    var didClickAddToCart: ((Product) -> Void)?
    
    static func cellSize(collectionView: UICollectionView) -> CGSize {
        let width = (collectionView.bounds.width - 45) / 2
        let height = 15 + (width - 30) + 5 + 15 + 5 + 15 + 5 + 15 + 10
        return CGSize(width: width, height: height)
    }
    
    @IBAction func clickAddToCartButton(sender: Any) {
        
    }
}

