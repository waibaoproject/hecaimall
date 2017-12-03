//
//  APIPath.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation

struct APIPath: URLRequestComponent {
    
    private let path: String
    let method: HTTPMethod
    let parameters: [String: Any]

    init(method: HTTPMethod = .get, path: String, parameters: [String: Any] = [:]) {
        self.path = path
        self.method = method
        self.parameters = parameters
    }
    
    var url: HTTPURLStringConvertible {
        return v1domain + path
    }
}

struct NextableAPIPath: URLRequestNextable {
 
    private let path: String
    private let parameters: [String: Any]
    private let offset: UInt
    private let limit: UInt
    
    init(path: String, parameters: [String: Any] = [:], offset: UInt = 0, limit: UInt = 20) {
        self.path = path
        self.parameters = parameters
        self.offset = offset
        self.limit = limit
    }
    
    var isFirst: Bool {
        return offset == 0
    }
    
    func first() -> NextableAPIPath {
        return NextableAPIPath(path: path, parameters: parameters, offset: 0, limit: limit)
    }
    
    func next() -> NextableAPIPath {
        return NextableAPIPath(path: path, parameters: parameters, offset: offset + limit, limit: limit)
    }
    
    public func asURLRequest() throws -> URLRequest {
        let newParameters = parameters <- ["offset": offset, "limit": limit]
        return try generateRequest(url: v1domain + path, parameters: newParameters)
    }
}
