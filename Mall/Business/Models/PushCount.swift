//
//  PushCount.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/29.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import GearNetwork
import Unbox

struct PushCount: Unboxable {
    let count: Int
    
    init(unboxer: Unboxer) throws {
        count = unboxer.unbox(key: "count") ?? 0
    }
}

extension PushCount: Modelable {}
