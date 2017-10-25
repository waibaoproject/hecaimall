//
//  RxAlamofire+JSON.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/7/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Alamofire
import RxSwift

public func json(urlRequest: URLRequestConvertible)
    -> Observable<Any> {
        return SessionManager.default.rx.json(urlRequest: urlRequest)
}

extension Reactive where Base: SessionManager {

    public func json(urlRequest: URLRequestConvertible)
        -> Observable<Any> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.json() }
    }
}

public func string(urlRequest: URLRequestConvertible)
    -> Observable<String> {
        return SessionManager.default.rx.string(urlRequest: urlRequest)
}

extension Reactive where Base: SessionManager {
    
    public func string(urlRequest: URLRequestConvertible)
        -> Observable<String> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.string() }
    }
}

public func data(urlRequest: URLRequestConvertible)
    -> Observable<Data> {
        return SessionManager.default.rx.data(urlRequest: urlRequest)
}

extension Reactive where Base: SessionManager {
    
    public func data(urlRequest: URLRequestConvertible)
        -> Observable<Data> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.data() }
    }
}
