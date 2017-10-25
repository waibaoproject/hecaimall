//
//  UIConfige.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SwiftHEXColors

protocol LabelConfig {
    var textColor: UIColor {get}
    var font: UIFont {get}
}


struct TitleLabelConfige: LabelConfig {
    let textColor = UIColor(hex: 0x333333)!
    let font = UIFont.systemFont(ofSize: 15)
}

extension UILabel {
    
    func setupConfig(_ config: LabelConfig) {
        textColor = config.textColor
        font = config.font
    }
}
