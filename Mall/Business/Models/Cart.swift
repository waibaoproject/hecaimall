//
//  Cart.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/14.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Cart: Unboxable {
    
    var items: [ProductItem]
    let totalPayment: Price
    
    init(unboxer: Unboxer) throws {
        items = unboxer.unbox(key: "items") ?? []
        totalPayment = unboxer.unbox(key: "total_payment") ?? .cent(0)
    }
}

extension Cart: Modelable {}

struct ProductItem: Unboxable {
    let product: Product
    var count: UInt
    var isSelected: Bool
    let isCommented: Bool
    
    init(unboxer: Unboxer) throws {
        product = try unboxer.unbox(key: "product")
        count = unboxer.unbox(key: "count") ?? 1
        isSelected = unboxer.unbox(key: "is_selected") ?? false
        isCommented = unboxer.unbox(key: "is_commented") ?? false
    }
}

extension ProductItem: Modelable {}
