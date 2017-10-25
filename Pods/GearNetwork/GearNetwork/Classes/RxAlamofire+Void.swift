//
//  RxAlamofire+Void.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/7/2.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Alamofire
import RxSwift

extension Reactive where Base: SessionManager {
    
    public func void(urlRequest: URLRequestConvertible)
        -> Observable<Void> {
            return request(urlRequest: urlRequest).flatMap { $0.rx.void() }
    }
}

extension Reactive where Base: SessionManager {
    
    public func void(_ method: Alamofire.HTTPMethod,
                     _ url: URLConvertible,
                     parameters: [String: Any]? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: [String: String]? = nil)
        -> Observable<Void> {
            return request(
                method,
                url,
                parameters: parameters,
                encoding: encoding,
                headers: headers
                ).flatMap { $0.rx.void() }
    }
}

extension Reactive where Base: DataRequest {
    
    public func void() -> Observable<Void> {
        return result(responseSerializer: Base.voidResponseSerializer())
    }
}

