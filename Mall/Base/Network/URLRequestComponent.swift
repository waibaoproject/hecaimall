//
//  NetworkProtocols.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import FoundationExtension
import Alamofire

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

protocol HTTPURLStringConvertible: URLRequestComponent {
    var urlString: String {get}
}

extension String {
    var url: HTTPURLStringConvertible {
        return self
    }
}

extension HTTPURLStringConvertible {
    var url: HTTPURLStringConvertible {
        return self
    }
}

protocol URLRequestComponent: URLRequestConvertible {
    var method: HTTPMethod {get}
    var url: HTTPURLStringConvertible {get}
    var parameters: [String: Any] {get}
    var headers: [String: String] {get}
}

extension String: HTTPURLStringConvertible {
    var urlString: String {
        return self
    }
}

extension URLRequestComponent {
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var headers: [String: String] {
        return [:]
    }
}


struct URLRequestEntity: URLRequestComponent {
    
    let method: HTTPMethod
    let url: HTTPURLStringConvertible
    let parameters: [String: Any]
    let headers: [String: String]
}

extension NSMutableURLRequest: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        return self as URLRequest
    }
}


extension URLRequestComponent {
    
    public func asURLRequest() throws -> URLRequest {
        return try generateRequest(method: method, url: url, parameters: parameters, headers: headers)
    }
}

func generateRequest(method: HTTPMethod = .get,
                     url: HTTPURLStringConvertible,
                     parameters: [String: Any],
                     headers: [String: String] = [:])
    throws -> URLRequest {
    
    let urlString = url.urlString
    guard let url = URL(string: urlString) else {
        throw "Construct URLRequest Error(bad url): \(urlString)"
    }
    
    let mutableURLRequest = NSMutableURLRequest(url: url)
    mutableURLRequest.httpMethod = method.rawValue
    
    var defaultHeaders: [String: String] = [:]
    // TODO: 替换accessToken
    defaultHeaders["X-AccessToken"] = LoginCenter.default.accessToken
    
    defaultHeaders["X-Debug-Version"] = Bundle.main.bundleVersion
    defaultHeaders["X-Release-Version"] = Bundle.main.bundleShortVersion
    defaultHeaders["X-DeviceId"] = UIDevice.current.deviceId
    
    defaultHeaders["X-OS"] = "iOS"
    defaultHeaders["X-Version"] = UIDevice.current.systemVersion
    
    mutableURLRequest.allHTTPHeaderFields = defaultHeaders <- headers
    
//        if method == .get {
            return try URLEncoding.default.encode(mutableURLRequest, with: parameters)
//        } else {
//            return try URLEncoding.httpBody.encode(mutableURLRequest, with: parameters)
//        }

}

extension URLRequestComponent {
    
    var debugDescription: String {
        
        var output: [String] = []
        output.append("\(method.rawValue) \(url.urlString)")
        output.append("[Parameters]: \(parameters)")
        output.append("[Headers]: \(headers)")
        return output.joined(separator: "\n")
    }
}
    
precedencegroup ComparativePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator <-: ComparativePrecedence

func <-<K, V>(left: [K: V], right: [K: V]) -> [K: V] {
    
    return right.flatMap { $0 }.reduce(left) { (result, tuple) -> [K: V] in
        var newResult = result
        newResult.updateValue(tuple.1, forKey: tuple.0)
        return newResult
    }
}


