//
//  Alamofire+Modelable.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/7/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Alamofire

extension DataRequest {
    
    public static func modelResponseSerializer<T: Modelable>(
        options: JSONSerialization.ReadingOptions = .allowFragments,
        atKey key: String? = nil)
        -> DataResponseSerializer<T> {
            return DataResponseSerializer { _, response, data, error in
                return Request.serializeResponseModel(options: options, atKey: key, response: response, data: data, error: error)
            }
    }
    
    @discardableResult
    public func responseModel<T: Modelable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        atKey key: String? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self {
            return response(
                queue: queue,
                responseSerializer: DataRequest.modelResponseSerializer(options: options, atKey: key),
                completionHandler: completionHandler
            )
    }
}

extension DataRequest {
    
    public static func modelsResponseSerializer<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false)
        -> DataResponseSerializer<Array<T>> {
            return DataResponseSerializer { _, response, data, error in
                return Request.serializeResponseModels(options: options, atKey: key, allowInvalidElements: allowInvalidElements, response: response, data: data, error: error)
            }
    }
    
    @discardableResult
    public func responseModels<T: Modelable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false,
        completionHandler: @escaping (DataResponse<Array<T>>) -> Void)
        -> Self {
            return response(
                queue: queue,
                responseSerializer: DataRequest.modelsResponseSerializer(options: options, atKey: key, allowInvalidElements: allowInvalidElements),
                completionHandler: completionHandler
            )
    }
}

extension DataRequest {
    
    public static func modelsResponseSerializer<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false)
        -> DataResponseSerializer<Set<T>> {
            return DataResponseSerializer { _, response, data, error in
                return Request.serializeResponseModels(options: options, atKey: key, allowInvalidElements: allowInvalidElements, response: response, data: data, error: error)
            }
    }
    
    @discardableResult
    public func responseModels<T: Modelable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false,
        completionHandler: @escaping (DataResponse<Set<T>>) -> Void)
        -> Self {
            return response(
                queue: queue,
                responseSerializer: DataRequest.modelsResponseSerializer(options: options, atKey: key, allowInvalidElements: allowInvalidElements),
                completionHandler: completionHandler
            )
    }
}

extension DataRequest {
    
    public static func modelsResponseSerializer<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false)
        -> DataResponseSerializer<[String: T]> {
            return DataResponseSerializer { _, response, data, error in
                return Request.serializeResponseModels(options: options, atKey: key, allowInvalidElements: allowInvalidElements, response: response, data: data, error: error)
            }
    }
    
    @discardableResult
    public func responseModels<T: Modelable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false,
        completionHandler: @escaping (DataResponse<[String: T]>) -> Void)
        -> Self {
            return response(
                queue: queue,
                responseSerializer: DataRequest.modelsResponseSerializer(options: options, atKey: key, allowInvalidElements: allowInvalidElements),
                completionHandler: completionHandler
            )
    }
}

extension Request {
    
    public static func serializeResponseModel<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<T> {
            return serializeResponseJSON(options: options, response: response, data: data, error: error).flatMap {
                try T.makeModel(fromValue: $0, atKey: key)
            }
    }
    
    public static func serializeResponseModels<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Array<T>> {
            return serializeResponseJSON(options: options, response: response, data: data, error: error).flatMap {
                try T.makeModels(fromValue: $0, atKey: key, allowInvalidElements: allowInvalidElements)
            }
    }
    
    public static func serializeResponseModels<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Set<T>> {
            return serializeResponseJSON(options: options, response: response, data: data, error: error).flatMap {
                try T.makeModels(fromValue: $0, atKey: key, allowInvalidElements: allowInvalidElements)
            }
    }
    
    public static func serializeResponseModels<T: Modelable>(
        options: JSONSerialization.ReadingOptions,
        atKey key: String? = nil,
        allowInvalidElements: Bool = false,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<[String: T]> {
            return serializeResponseJSON(options: options, response: response, data: data, error: error).flatMap {
                try T.makeModels(fromValue: $0, atKey: key, allowInvalidElements: allowInvalidElements)
            }
    }
}
