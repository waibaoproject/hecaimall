//
//  User.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/9.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork


struct User: Unboxable {
    
    let id: String
    let nickname: String?
    let avatar: URL?
    let birthdate: Date?
    let isMale: Bool
    let phone: String?
    let email: String?
    let cityCode: UInt
    let healths: [KeyValue]
    let isAdmin: Bool
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        nickname = unboxer.unbox(key: "nickname")
        avatar = unboxer.unbox(key: "avatar")
        birthdate = unboxer.unbox(key: "birthdate")
        isMale = unboxer.unbox(key: "is_male") ?? false
        phone = unboxer.unbox(key: "phone")
        email = unboxer.unbox(key: "email")
        cityCode = unboxer.unbox(key: "city_code") ?? 0
        healths = unboxer.unbox(key: "healths") ?? []
        isAdmin = unboxer.unbox(key: "is_admin") ?? false
    }
}

extension User: Modelable {}

struct KeyValue: Unboxable {
    let key: String
    let value: String
    
    init(unboxer: Unboxer) throws {
        key = unboxer.unbox(key: "key") ?? ""
        value = unboxer.unbox(key: "value") ?? ""
    }
}
