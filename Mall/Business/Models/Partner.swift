//
//  Partner.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/22.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Partner: Unboxable {
    let id: String
    let name: String
    let type: String
    let customers: Int
    let principal: String
    let address: String
    let districtCode: UInt
    let icon: URL?
    let phone: String?
    let appQrCode: URL?
    let wechatQrCode: URL?
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        name = unboxer.unbox(key: "name") ?? ""
        type = unboxer.unbox(key: "type") ?? ""
        customers = unboxer.unbox(key: "customers") ?? 0
        principal = unboxer.unbox(key: "principal") ?? ""
        address = unboxer.unbox(key: "address") ?? ""
        districtCode = unboxer.unbox(key: "district_code") ?? 0
        icon = unboxer.unbox(key: "icon")
        phone = unboxer.unbox(key: "phone")
        appQrCode = unboxer.unbox(key: "qr_code_url_app")
        wechatQrCode = unboxer.unbox(key: "qr_code_url_wechat")
    }
}

struct PartnerType: Unboxable {
    let id: String
    let name: String
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
    }
}

extension Partner: Modelable {}
extension PartnerType: Modelable {}
