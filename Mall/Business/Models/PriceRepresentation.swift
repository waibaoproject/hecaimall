//
//  PriceRepresentation.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

enum Price: UnboxableByTransform {
    
    case cent(UInt)
    case yuan(UInt)
    
    var cent: UInt {
        switch self {
        case let .cent(value):
            return value
        case let .yuan(value):
            return value * 100
        }
    }
    
    var yuan: Double {
        switch self {
        case let .cent(value):
            return Double(value) / 100
        case let .yuan(value):
            return Double(value)
        }
    }
    
    var display: String {
        switch self {
        case let .cent(value):
            return String(format: "¥%.2f", Double(value) / 100.0)
        case let .yuan(value):
            return String(format: "¥%.2f", value)
        }
    }
    
    var displayYuan: String {
        switch self {
        case let .cent(value):
            return String(format: "¥%.2f元", Double(value) / 100.0)
        case let .yuan(value):
            return String(format: "¥%.2f元", value)
        }
    }
    
    typealias UnboxRawValue = UInt
    
    static func transform(unboxedValue: UnboxRawValue) -> Price? {
        return .cent(unboxedValue)
    }
}

extension Price: Modelable {}


