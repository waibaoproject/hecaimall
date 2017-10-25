//
//  Alamofire+Void.swift
//  RxAlamofireDemo
//
//  Created by 王小涛 on 2017/6/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Alamofire
import RxSwift

extension DataRequest {
    
    public static func voidResponseSerializer() -> DataResponseSerializer<Void> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseVoid(response: response, data: data, error: error)
        }
    }
    
    @discardableResult
    public func responseVoid(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Void>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.voidResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}

extension Request {
    
    public static func serializeResponseVoid(
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Void>
    {
        guard error == nil else { return .failure(error!) }
        return .success(Void())
    }
}
