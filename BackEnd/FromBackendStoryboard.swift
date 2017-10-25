//
//  FromBackendStoryboard.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable

protocol FromBackendStoryboard: StoryboardSceneBased {}

extension FromBackendStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Backend", bundle: nil)
    }
}

