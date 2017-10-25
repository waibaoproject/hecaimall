//
//  CustomService.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct CustomService: Unboxable {
    let hotline: String
    let qqs: [String]
    let wechats: [String]
    
    init(unboxer: Unboxer) throws {
        hotline = unboxer.unbox(key: "hotline") ?? ""
        qqs = unboxer.unbox(key: "qqs") ?? []
        wechats = unboxer.unbox(key: "wechats") ?? []
    }
}

extension CustomService: Modelable {}
