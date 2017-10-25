//
//  FromOtherStroyboard.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable

protocol FromOtherStroyboard: StoryboardSceneBased {}

extension FromOtherStroyboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Other", bundle: nil)
    }
}

