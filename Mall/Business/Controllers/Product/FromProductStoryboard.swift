//
//  FromProductStoryboard.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/27.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable

protocol FromProductStoryboard: StoryboardSceneBased {}

extension FromProductStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Product", bundle: nil)
    }
}
