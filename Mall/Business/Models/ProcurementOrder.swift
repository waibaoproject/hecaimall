//
//  ProcurementOrder.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/22.
//  Copyright © 2017年 王小涛. All rights reserved.
//


import Unbox
import GearNetwork

struct ProcurementOrder: Unboxable {
    let id: String
    let orderNumber: String?
    let superior: String?
    let type: String
    let productName: String?
    let count: Int
    let payType: String?
    let createDate: Date?
    let stock: Int
    let totalPayment: Price
    let state: ProcurementOrderState
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        orderNumber = unboxer.unbox(key: "order_no")
        superior = unboxer.unbox(key: "superior")
        type = unboxer.unbox(key: "type") ?? ""
        productName = unboxer.unbox(key: "product_name")
        count = unboxer.unbox(key: "count") ?? 0
        payType = unboxer.unbox(key: "pay_type")
        createDate = unboxer.unbox(key: "create_time")
        stock = unboxer.unbox(key: "stock") ?? 0
        totalPayment = unboxer.unbox(key: "total_payment") ?? .cent(0)
        state = unboxer.unbox(key: "state") ?? .notPay
    }
}

enum ProcurementOrderState: Int, UnboxableEnum {
    case notPay = 0
    case paid = 10
    case waitForProcess = 50
    case passed = 60
    case rejected = 70
}

extension ProcurementOrder: Modelable {}

