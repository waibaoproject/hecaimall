//
//  Modelable+Unbox.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/5/27.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox

// Unboxable Object
extension Modelable where Self: Unboxable {
    public init(value: Any) throws {
        guard let value = value as? UnboxableDictionary else {
            throw UnboxError.invalidData
        }
        self = try unbox(dictionary: value)
    }
}

// UnboxableRawType, UnboxableByTransform
extension Modelable where Self: UnboxCompatible {
    public init(value: Any) throws {
        if let model = try Self.unbox(value: value, allowInvalidCollectionElements: false) {
            self = model
        }else {
            throw UnboxError.invalidData
        }
    }
}

// UnboxableEnum
extension Modelable where Self: UnboxableEnum {
    public init(value: Any) throws {
        if let model = try Self.unbox(value: value, allowInvalidCollectionElements: false) {
            self = model
        }else {
            throw UnboxError.invalidData
        }
    }
}

//protocol EnumModelable: Modelable, UnboxableEnum {}
//
//extension EnumModelable {
//    init(value: Any) throws {
//        if let model = try Self.unbox(value: value, allowInvalidCollectionElements: false) {
//            self = model
//        }else {
//            throw UnboxError.invalidData
//        }
//    }
//}

extension Date: UnboxableRawType {
    
    public static func transform(unboxedNumber: NSNumber) -> Date? {
        return Date(timeIntervalSince1970: unboxedNumber.doubleValue)
    }
    
    public static func transform(unboxedString: String) -> Date? {
        guard let timestamp = TimeInterval(unboxedString) else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }
}

extension Bool: Modelable {}

extension Int: Modelable {}
extension Int32: Modelable {}
extension Int64: Modelable {}
extension UInt: Modelable {}
extension UInt32: Modelable {}
extension UInt64: Modelable {}

extension CGFloat: Modelable {}
extension Float: Modelable {}
extension Double: Modelable {}
extension Decimal: Modelable {}

extension String: Modelable {}

extension URL: Modelable {}

extension Date: Modelable {}

