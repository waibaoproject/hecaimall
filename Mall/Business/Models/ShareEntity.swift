//
//  ShareEntity.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox

struct ShareEntity: Unboxable {
    
    let title: String?
    let text: String?
    let thumbnail: String?
    let link: String?
    
    init(unboxer: Unboxer) throws {
        title = unboxer.unbox(key: "title")
        text = unboxer.unbox(key: "text")
        thumbnail = unboxer.unbox(key: "thumbnail")
        link = unboxer.unbox(key: "link")
    }
}
