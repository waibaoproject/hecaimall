//
//  Channel.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/22.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Channel: Unboxable {
    let id: String
    let name: String?
    let type: String
    let icon: URL?
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        name = unboxer.unbox(key: "name")
        type = unboxer.unbox(key: "type") ?? ""
        icon = unboxer.unbox(key: "icon")
    }
}

extension Channel: Modelable {}


struct Warehouse: Unboxable {
    
    let id: String
    let product: Product?
    let stock: Int
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        product = unboxer.unbox(key: "product")
        stock = unboxer.unbox(key: "stock") ?? 0
    }
}

extension Warehouse: Modelable {}
