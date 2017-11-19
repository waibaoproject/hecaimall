//
//  GridCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/18.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class GridCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!

    var tab: GridTab! {
        didSet {
            nameLabel.text = tab?.name
            iconImageView.image = tab?.icon
            if let count = tab.count {
                countLabel.text = String(count)
            } else {
                countLabel.text = "0"
            }
            badgeLabel.text = String(tab.badge)
            iconImageView.isHidden = tab.count != nil
            countLabel.isHidden = tab.count == nil
            badgeLabel.isHidden = tab.badge == 0
        }
    }
}
