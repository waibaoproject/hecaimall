//
//  HomeProductGroupCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable
import WebImage

class HomeProductCell: UITableViewCell, Reusable {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var product: Product? {
        didSet {
            let url = product?.cover
            coverImageView.web.setImage(with: url)
            nameLabel.text = product?.name
            priceLabel.text = product?.price.display
        }
    }

}
