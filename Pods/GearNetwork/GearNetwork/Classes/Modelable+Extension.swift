//
//  Modelable+Extension.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/7/2.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation

enum ModelableError: Error {
    case missingKey(String)
}

extension Modelable {
    
    private static func valueToModel(fromValue value: Any, atKey key: String? = nil) throws -> Any {
        if let key = key {
            if let value = (value as AnyObject).value(forKey: key) {
                return value
            }else  {
                throw ModelableError.missingKey(key)
            }
        } else {
            return value
        }
    }
    
    public static func makeModel<T: Modelable>(fromValue value: Any, atKey key: String? = nil) throws -> T {
        return try T(value: try valueToModel(fromValue: value, atKey: key))
    }
    
    public static func makeModels<T: Modelable>(fromValue value: Any, atKey key: String? = nil, allowInvalidElements: Bool = false) throws -> Array<T> {
        
        guard let values = try valueToModel(fromValue: value, atKey: key) as? [Any] else {return []}
        if !allowInvalidElements {
            return try values.map{try T(value: $0)}
        }else {
            return values.flatMap{try? T(value: $0)}
        }
    }
    
    public static func makeModels<T: Modelable>(fromValue value: Any, atKey key: String? = nil, allowInvalidElements: Bool = false) throws -> Set<T> {
        guard let values = try valueToModel(fromValue: value, atKey: key) as? [Any] else {return []}
        if !allowInvalidElements {
            return Set(try values.map{try T(value: $0)})
        }else {
            return Set(values.flatMap{try? T(value: $0)})
        }
    }
    
    static func makeModels<T: Modelable>(fromValue value: Any, atKey key: String? = nil, allowInvalidElements: Bool = false) throws -> [String: T] {
        guard let values = try valueToModel(fromValue: value, atKey: key) as? [String: Any] else {return [:]}
        
        let models: [String: T] = try values.reduce([:]) { initial, model in
            var result = initial
            if !allowInvalidElements {
                result[model.key] = try T(value: model.value)
            }else {
                result[model.key] = try? T(value: model.value)
            }
            return result
        }
        return models
    }
}
