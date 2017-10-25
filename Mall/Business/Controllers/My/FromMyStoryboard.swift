//
//  FromMyStoryboard.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable

protocol FromMyStoryboard: StoryboardSceneBased {}

extension FromMyStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "My", bundle: nil)
    }
}

