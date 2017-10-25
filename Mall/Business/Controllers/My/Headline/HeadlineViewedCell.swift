//
//  HeadlineViewedCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class HeadlineViewedCell: UITableViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var left: NSLayoutConstraint!
    
    var headline: Headline? {
        didSet {
            titleLabel.text = headline?.title
            coverImageView.web.setImage(with: headline?.cover)
            descLabel.text = headline?.desc
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
