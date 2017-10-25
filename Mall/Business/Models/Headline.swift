//
//  Headline.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Headline: Unboxable {
    
    let id: String
    let title: String?
    let desc: String?
    let cover: URL?
    let link: URL?
    let shareEntity: ShareEntity?
    let footDate: Date
    var isFavorited: Bool
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        title = unboxer.unbox(key: "title")
        desc = unboxer.unbox(key: "desc")
        cover = unboxer.unbox(key: "cover")
        link = unboxer.unbox(key: "link")
        shareEntity = unboxer.unbox(key: "shareEntity")
        footDate = unboxer.unbox(key: "foot_time") ?? Date(timeIntervalSince1970: 0)
        isFavorited = unboxer.unbox(key: "favorited") ?? false
    }
}

extension Headline: Modelable {}
