//
//  ProductGroupHeader.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/21.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import FoundationExtension
import WebImage

class ProductGroupHeader: UITableViewCell, NibReusable {
    
    @IBOutlet weak var coverImageImage: UIImageView! {
        didSet {
            coverImageImage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer()
            coverImageImage.addGestureRecognizer(tap)
        }
    }
    
    var productGroup: ProductGroup? {
        didSet {
            coverImageImage.web.setImage(with: productGroup?.cover)
        }
    }
}
