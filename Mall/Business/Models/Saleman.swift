//
//  Saleman.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/22.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Salesman: Unboxable {
    let id: String
    let name: String?
    let phone: String
    let distributors: String?
    let qrCodeUrl: URL?
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        name = unboxer.unbox(key: "name")
        phone = unboxer.unbox(key: "phone") ?? ""
        distributors = unboxer.unbox(key: "distributors")
        qrCodeUrl = unboxer.unbox(key: "qr_code_url")
    }
}

extension Salesman: Modelable {}
