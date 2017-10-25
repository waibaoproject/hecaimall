//
//  SaleManCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class SaleManCell: UITableViewCell, Reusable {
    @IBOutlet weak var nameLabel: UILabel!
    
    var saleman: Salesman! {
        didSet {
            nameLabel.text = saleman.name
        }
    }
}

