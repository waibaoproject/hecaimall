//
//  Product.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct ProductGroup: Unboxable {
    let id: String
    //商品类型名称
    let type: String?  // 菩萨囊、医疗品
    //类型封面
    let cover: URL?
    //类型描述
    let desc: String?
    //商品列表
    let products: [Product]
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        type = unboxer.unbox(key: "type")
        cover = unboxer.unbox(key: "cover")
        desc = unboxer.unbox(key: "desc")
        products = unboxer.unbox(key: "products") ?? []
    }
}

struct Product: Unboxable {
    // 商品id
    let id: String
    // 商品名称
    let name: String
    /// 类型：基层医疗、鹤年堂
    let type: String?
    // 商品价格
    let price: Price
    // 商品封面图
    let cover: URL?
    // 每月销量
    let salesCount: UInt
    // 商品邮费
    let expressFee: Price
    // 商品分享实体
    let shareEntity: ShareEntity?
    // 图文详情
    let detailURL: URL?
    // 推荐指数(用于综合排序)
    let recommandScore: UInt
    
    let images: [URL]
    
    var isFavorited: Bool = false
    
    let footDate: Date
    
    let stock: Int
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = unboxer.unbox(key: "name") ?? ""
        type = unboxer.unbox(key: "type")
        price = unboxer.unbox(key: "price") ?? .cent(0)
        cover = unboxer.unbox(key: "cover")
        salesCount = unboxer.unbox(key: "sales_count") ?? 0
        expressFee = unboxer.unbox(key: "express_fee") ?? .cent(0)
        shareEntity = unboxer.unbox(key: "share_entity")
        detailURL = unboxer.unbox(key: "detail_url")
        recommandScore = unboxer.unbox(key: "recommand_score") ?? 0
        images = unboxer.unbox(key: "covers") ?? []
        
        isFavorited = unboxer.unbox(key: "favorited") ?? false
        footDate = unboxer.unbox(key: "foot_time") ?? Date(timeIntervalSince1970: 0)
        stock = unboxer.unbox(key: "stock") ?? 0
    }
    
    init(id: String) {
        self.id = id
        name = ""
        type = ""
        price = .cent(0)
        cover = nil
        salesCount = 0
        expressFee = .cent(0)
        shareEntity = nil
        detailURL = nil
        recommandScore = 0
        images = []
        isFavorited = false
        footDate = Date()
        stock = 0
    }
}

extension ProductGroup: Modelable {}

extension Product: Modelable {}

