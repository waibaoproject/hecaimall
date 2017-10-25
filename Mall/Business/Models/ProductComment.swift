//
//  ProductComment.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct ProductComment: Unboxable {
    // 评论id
    let id: String
    // 好评中评差评 1好评，2中评，3差评
    let rating: Int
    // 评论内容
    let content: String
    // 评论图片 暂定4张最多
    let images: [URL]
    // 发表评论的用户
    let user: User?
    // 被评论的商品
    let product: Product?
    // 创建日期
    let createAt: Date?
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        rating = unboxer.unbox(key: "rating") ?? 1
        content = unboxer.unbox(key: "content") ?? ""
        images = unboxer.unbox(key: "images") ?? []
        user = unboxer.unbox(key: "user")
        product = unboxer.unbox(key: "product")
        createAt = unboxer.unbox(key: "create_at")
    }
}

extension ProductComment: Modelable {}
