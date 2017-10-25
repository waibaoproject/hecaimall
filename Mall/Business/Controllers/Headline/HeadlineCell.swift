//
//  HeadlineCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class HeadlineCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
  

    var headline: Headline? {
        didSet {
            titleLabel.text = headline?.title
            coverImageView.web.setImage(with: headline?.cover)
            descLabel.text = headline?.desc
        }
    }
}
