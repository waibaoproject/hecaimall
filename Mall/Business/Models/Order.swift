//
//  Order.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/14.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Order: Unboxable {
    // 订单id
    let id: String
    // 订单号
    let number: String
    // 订单项
    var items: [ProductItem]
    
    // 收货人信息
    var receiver: Receiver?
    // 快递费用
    let expressFee: Price
    // 买家留言
    let remark: String?
    // 订单状态
    let state: OrderState
    
    let deliveryProgressUrl: URL?
    // 总金额
    let totalPayment: Price
    
    let partnerName: String?
    let createDate: Date?
    
    let productCount: Int
    
    let payDate: Date?
    let deliverDate: Date?
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        number = unboxer.unbox(key: "number") ?? ""
        items = unboxer.unbox(key: "items") ?? []
        receiver = unboxer.unbox(key: "receiver")
        expressFee = unboxer.unbox(key: "express_fee") ?? .cent(0)
        remark = unboxer.unbox(key: "remark")
        state = unboxer.unbox(key: "state") ?? .canceled
        deliveryProgressUrl = unboxer.unbox(key: "delivery_progress_url")
        totalPayment = unboxer.unbox(key: "total_payment") ?? .cent(0)
        partnerName = unboxer.unbox(key: "partner_name")
        createDate = unboxer.unbox(key: "create_time")
        
        productCount = unboxer.unbox(key: "product_count") ?? 0
        payDate = unboxer.unbox(key: "pay_time")
        deliverDate = unboxer.unbox(key: "delivert_time")
    }
}

extension Order: Modelable {}

enum OrderState: Int, UnboxableEnum {
    // 待支付
    case waitForPay = 0
    // 待发货
    case waitForDeliver = 20
    // 待收货
    case waitForReceive = 40
    // 订单完成
    case end = 80
    // 订单取消
    case canceled = -1
    
    var desc: String {
        switch self {
        case .waitForPay:
            return "等待买家付款"
        case .waitForDeliver:
            return "等待发货"
        case .waitForReceive:
            return "等待收货"
        case .end:
            return "已完成"
        case .canceled:
            return "已取消"
        }
    }
}

extension OrderState: Modelable {}


struct Receiver: Unboxable {
    // id
    let id: String
    // 收货人
    var name: String
    // 联系电话
    var phone: String
    // 所在地区
    var districtCode: UInt
    // 详细地址
    var detail: String
    // 是否是默认收货人
    var isDefault: Bool
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        phone = unboxer.unbox(key: "phone") ?? ""
        districtCode = unboxer.unbox(key: "district_code") ?? 0
        detail = unboxer.unbox(key: "detail") ?? ""
        isDefault = unboxer.unbox(key: "is_default") ?? false
    }
}

extension Receiver {
    init() {
        id = ""
        name = ""
        phone = ""
        districtCode = 0
        detail = ""
        isDefault = false
    }
}

extension Receiver: Modelable {}

