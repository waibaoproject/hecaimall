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
    let appQrCode: URL?
    let wechatQrCode: URL?
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        name = unboxer.unbox(key: "name")
        phone = unboxer.unbox(key: "phone") ?? ""
        distributors = unboxer.unbox(key: "distributors")
        appQrCode = unboxer.unbox(key: "qr_code_url_app")
        wechatQrCode = unboxer.unbox(key: "qr_code_url_wechat")
    }
}

extension Salesman: Modelable {}
