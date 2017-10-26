//
//  FromBuyStoryboard.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/26.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable

protocol FromBuyStoryboard: StoryboardSceneBased {}

extension FromBuyStoryboard {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Buy", bundle: nil)
    }
}


