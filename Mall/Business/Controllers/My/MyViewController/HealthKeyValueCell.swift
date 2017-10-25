//
//  HealthKeyValueCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/12.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class HealthKeyValueCell: UITableViewCell, Reusable {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextField!
    
    var health: KeyValue! {
        didSet {
            keyLabel.text = health.key
            valueLabel.text = health.value.isBlankString ? "请选择" : health.value
        }
    }
}
