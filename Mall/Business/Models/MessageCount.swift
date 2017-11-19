//
//  MessageCount.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct MessageCount: Unboxable {
    let productsFavoritedCount: Int
    let headlinesFavoritedCount: Int
    let productsViewedCount: Int
    let headlinesViewedCount: Int
    let ordersWaitForPay: Int
    let ordersWaitForDeliver: Int
    let ordersWaitForReceive: Int
    let ordersWaitForComment: Int
    
    init(unboxer: Unboxer) throws {
        productsFavoritedCount = unboxer.unbox(key: "products_favorited_count") ?? 0
        headlinesFavoritedCount = unboxer.unbox(key: "headlines_favorited_count") ?? 0
        productsViewedCount = unboxer.unbox(key: "products_viewed_count") ?? 0
        headlinesViewedCount = unboxer.unbox(key: "headlines_viewed_count") ?? 0
        ordersWaitForPay = unboxer.unbox(key: "ordersWait_for_pay") ?? 0
        ordersWaitForDeliver = unboxer.unbox(key: "ordersWait_for_deliver") ?? 0
        ordersWaitForReceive = unboxer.unbox(key: "ordersWait_for_receive") ?? 0
        ordersWaitForComment = unboxer.unbox(key: "ordersWait_for_comment") ?? 0
    }
}

extension MessageCount {
    init() {
        productsFavoritedCount = 0
        headlinesFavoritedCount = 0
        productsViewedCount = 0
        headlinesViewedCount = 0
        ordersWaitForPay = 0
        ordersWaitForDeliver = 0
        ordersWaitForReceive = 0
        ordersWaitForComment = 0
    }
}

extension MessageCount: Modelable {}
