//
//  RxAlamofire+Modelable.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/5/27.
//  Copyright © 2017年 王小涛. All rights reserved.
//

//import RxAlamofire
import Alamofire
import RxSwift

public func model<T: Modelable>(urlRequest: URLRequestConvertible,
           atKey key: String? = nil)
    -> Observable<T> {
        return SessionManager.default.rx.model(urlRequest: urlRequest, atKey: key)
}

public func models<T: Modelable>(urlRequest: URLRequestConvertible,
            atKey key: String? = nil,
            allowInvalidElements: Bool = false)
    -> Observable<Array<T>> {
        return SessionManager.default.rx.models(urlRequest: urlRequest, atKey: key, allowInvalidElements: allowInvalidElements)
}

public func models<T: Modelable>(urlRequest: URLRequestConvertible,
            atKey key: String? = nil,
            allowInvalidElements: Bool = false)
    -> Observable<Set<T>> {
        return SessionManager.default.rx.models(urlRequest: urlRequest, atKey: key, allowInvalidElements: allowInvalidElements)
}

public func models<T: Modelable>(urlRequest: URLRequestConvertible,
            atKey key: String? = nil,
            allowInvalidElements: Bool = false)
    -> Observable<[String: T]> {
        return SessionManager.default.rx.models(urlRequest: urlRequest, atKey: key, allowInvalidElements: allowInvalidElements)
}

public func model<T: Modelable>(_ method: Alamofire.HTTPMethod,
           _ url: URLConvertible,
           parameters: [String: Any]? = nil,
           encoding: ParameterEncoding = URLEncoding.default,
           headers: [String: String]? = nil,
           atKey key: String? = nil)
    -> Observable<T> {
        return SessionManager.default.rx.model(method, url, parameters: parameters, encoding: encoding, headers: headers, atKey: key)
}

public func models<T: Modelable>(_ method: Alamofire.HTTPMethod,
            _ url: URLConvertible,
            parameters: [String: Any]? = nil,
            encoding: ParameterEncoding = URLEncoding.default,
            headers: [String: String]? = nil,
            atKey key: String? = nil,
            allowInvalidElements: Bool = false)
    -> Observable<Array<T>> {
        return SessionManager.default.rx.models(method, url, parameters: parameters, encoding: encoding, headers: headers, atKey: key)
}

public func models<T: Modelable>(_ method: Alamofire.HTTPMethod,
            _ url: URLConvertible,
            parameters: [String: Any]? = nil,
            encoding: ParameterEncoding = URLEncoding.default,
            headers: [String: String]? = nil,
            atKey key: String? = nil,
            allowInvalidElements: Bool = false)
    -> Observable<Set<T>> {
        return SessionManager.default.rx.models(method, url, parameters: parameters, encoding: encoding, headers: headers, atKey: key)
}

public func models<T: Modelable>(_ method: Alamofire.HTTPMethod,
            _ url: URLConvertible,
            parameters: [String: Any]? = nil,
            encoding: ParameterEncoding = URLEncoding.default,
            headers: [String: String]? = nil,
            atKey key: String? = nil,
            allowInvalidElements: Bool = false)
    -> Observable<[String: T]> {
        return SessionManager.default.rx.models(method, url, parameters: parameters, encoding: encoding, headers: headers, atKey: key)
}


extension Reactive where Base: SessionManager {
    
    public func model<T: Modelable>(urlRequest: URLRequestConvertible,
               atKey key: String? = nil)
        -> Observable<T> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.model(atKey: key) }
    }
    
    public func models<T: Modelable>(urlRequest: URLRequestConvertible,
                atKey key: String? = nil,
                allowInvalidElements: Bool = false)
        -> Observable<Array<T>> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.models(atKey: key, allowInvalidElements: allowInvalidElements) }
    }
    
    public func models<T: Modelable>(urlRequest: URLRequestConvertible,
                atKey key: String? = nil,
                allowInvalidElements: Bool = false)
        -> Observable<Set<T>> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.models(atKey: key, allowInvalidElements: allowInvalidElements) }
    }
    
    public func models<T: Modelable>(urlRequest: URLRequestConvertible,
                atKey key: String? = nil,
                allowInvalidElements: Bool = false)
        -> Observable<[String: T]> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.models(atKey: key, allowInvalidElements: allowInvalidElements) }
    }
}

extension Reactive where Base: SessionManager {
    
    public func model<T: Modelable>(_ method: Alamofire.HTTPMethod,
               _ url: URLConvertible,
               parameters: [String: Any]? = nil,
               encoding: ParameterEncoding = URLEncoding.default,
               headers: [String: String]? = nil,
               atKey key: String? = nil)
        -> Observable<T> {
            return request(
                method,
                url,
                parameters: parameters,
                encoding: encoding,
                headers: headers
                ).flatMap { $0.rx.model(atKey: key) }
    }
    
    public func models<T: Modelable>(_ method: Alamofire.HTTPMethod,
                _ url: URLConvertible,
                parameters: [String: Any]? = nil,
                encoding: ParameterEncoding = URLEncoding.default,
                headers: [String: String]? = nil,
                atKey key: String? = nil,
                allowInvalidElements: Bool = false)
        -> Observable<Array<T>> {
            return request(
                method,
                url,
                parameters: parameters,
                encoding: encoding,
                headers: headers
                ).flatMap { $0.rx.models(atKey: key, allowInvalidElements: allowInvalidElements) }
    }
    
    public func models<T: Modelable>(_ method: Alamofire.HTTPMethod,
                _ url: URLConvertible,
                parameters: [String: Any]? = nil,
                encoding: ParameterEncoding = URLEncoding.default,
                headers: [String: String]? = nil,
                atKey key: String? = nil,
                allowInvalidElements: Bool = false)
        -> Observable<Set<T>> {
            return request(
                method,
                url,
                parameters: parameters,
                encoding: encoding,
                headers: headers
                ).flatMap { $0.rx.models(atKey: key, allowInvalidElements: allowInvalidElements) }
    }
    
    public func models<T: Modelable>(_ method: Alamofire.HTTPMethod,
                _ url: URLConvertible,
                parameters: [String: Any]? = nil,
                encoding: ParameterEncoding = URLEncoding.default,
                headers: [String: String]? = nil,
                atKey key: String? = nil,
                allowInvalidElements: Bool = false)
        -> Observable<[String: T]> {
            return request(
                method,
                url,
                parameters: parameters,
                encoding: encoding,
                headers: headers
                ).flatMap { $0.rx.models(atKey: key, allowInvalidElements: allowInvalidElements) }
    }
}

extension Reactive where Base: DataRequest {
    
    public func model<T: Modelable>(options: JSONSerialization.ReadingOptions = .allowFragments, atKey key: String? = nil) -> Observable<T> {
        return result(responseSerializer: Base.modelResponseSerializer(options: options, atKey: key))
    }
    
    public func models<T: Modelable>(options: JSONSerialization.ReadingOptions = .allowFragments, atKey key: String? = nil, allowInvalidElements: Bool = false) -> Observable<Array<T>> {
        return result(responseSerializer: Base.modelsResponseSerializer(options: options, atKey: key, allowInvalidElements: allowInvalidElements))
    }
    
    public func models<T: Modelable>(options: JSONSerialization.ReadingOptions = .allowFragments, atKey key: String? = nil, allowInvalidElements: Bool = false) -> Observable<Set<T>> {
        return result(responseSerializer: Base.modelsResponseSerializer(options: options, atKey: key, allowInvalidElements: allowInvalidElements))
    }
    
    public func models<T: Modelable>(options: JSONSerialization.ReadingOptions = .allowFragments, atKey key: String? = nil, allowInvalidElements: Bool = false) -> Observable<[String: T]> {
        return result(responseSerializer: Base.modelsResponseSerializer(options: options, atKey: key, allowInvalidElements: allowInvalidElements))
    }
}


