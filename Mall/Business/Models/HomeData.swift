//
//  HomeData.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/8.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct HomeData: Unboxable {
    //轮播图
    let banners: [Banner]
    //资讯
    let headlines: [Headline]
    //商品组
    let productGroups: [ProductGroup]
 
    init(unboxer: Unboxer) throws {
        banners = unboxer.unbox(key: "banners") ?? []
        headlines = unboxer.unbox(key: "headlines") ?? []
        productGroups = unboxer.unbox(key: "productGroups") ?? []
    }
}

extension HomeData: Modelable {}
