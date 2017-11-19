//
//  GridTab.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/18.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

struct GridTab {
    let name: String
    var count: Int?
    let icon: UIImage
    var badge: Int = 0
    let handler: () -> Void
    
    init(name: String, count: Int? = nil, icon: UIImage, badge: Int = 0, handler: @escaping () -> Void) {
        self.name = name
        self.count = count
        self.icon = icon
        self.badge = badge
        self.handler = handler
    }
}
