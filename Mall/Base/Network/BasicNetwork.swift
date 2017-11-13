//
//  BasicNetwork.swift
//  GearNetwork
//
//  Created by 王小涛 on 2017/9/7.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import GearNetwork
import RxSwift
import Alamofire


protocol DataSource {
    func response<T: Modelable>(accessory: RequestAccessory?, key: String?) -> Observable<T>
}

protocol ArrayDataSource {
    func response<T: Modelable>(accessory: RequestAccessory?) -> Observable<[T]>
}

protocol NextableArrayDataSource: ArrayDataSource {
    var isFirst: Bool {get}
    func first() -> Self
    func next() -> Self
}

class DefaultDataSource: DataSource {
    
    let api: URLRequestConvertible

    init(api: URLRequestConvertible) {
        self.api = api
    }
    
    func response<T: Modelable>(accessory: RequestAccessory?, key: String? = nil) -> Observable<T> {
        return responseData(accessory: accessory, urlRequest: api, key: key).map {
            return try T(value: $0)
        }
    }
}

class DefaultArrayDataSource: ArrayDataSource {
    
    let api: URLRequestConvertible
    
    init(api: URLRequestConvertible) {
        self.api = api
    }
    
    func response<T: Modelable>(accessory: RequestAccessory?) -> Observable<[T]> {
        return responseData(accessory: accessory, urlRequest: api).map {
            return try T.makeModels(fromValue: $0)
        }
    }
}


protocol URLRequestNextable: URLRequestConvertible {
    var isFirst: Bool {get}
    func first() -> Self
    func next() -> Self
}

final class DefaultNextableArrayDataSource: NextableArrayDataSource {
    
    let api: URLRequestNextable
    
    init(api: URLRequestNextable) {
        self.api = api
    }
    
    func response<T: Modelable>(accessory: RequestAccessory?) -> Observable<[T]> {
        return responseData(accessory: accessory, urlRequest: api).map {
            return try T.makeModels(fromValue: $0)
        }
    }
    
    var isFirst: Bool {
        return api.isFirst
    }
    
    func first() -> DefaultNextableArrayDataSource {
        return DefaultNextableArrayDataSource(api: api.first())
    }

    func next() -> DefaultNextableArrayDataSource {
        return DefaultNextableArrayDataSource(api: api.next())
    }
}

func responseVoid(accessory: RequestAccessory?, urlRequest: URLRequestConvertible) -> Observable<Void> {
    
    accessory?.requestWillStart()
    return SessionManager.default.rx.json(urlRequest: urlRequest).map {
        
        print("=================================================================\n")
        print(urlRequest)
        let headers = (try? urlRequest.asURLRequest().allHTTPHeaderFields) ?? [:]
        print("Headers: \(String(describing: headers))")
        print("Response: \($0)")
        print("=================================================================\n")
        
            accessory?.requestDidStop()
            _ = try parseData($0)
            return
        }.catchErrorWithComplete(handler: {
            accessory?.requestDidStop()
            UIApplication.shared.keyWindow?.noticeOnlyText($0.localizedDescription)
            if $0.code == 40001 {
                LoginCenter.default.forceLogin()
            }
        })
}

private func responseData(accessory: RequestAccessory?, urlRequest: URLRequestConvertible, key: String? = nil) -> Observable<Any> {
    
    accessory?.requestWillStart()
    
    return SessionManager.default.rx.json(urlRequest: urlRequest).map {
        
        print("=================================================================\n")
        print(urlRequest)
        let headers = (try? urlRequest.asURLRequest().allHTTPHeaderFields) ?? [:]
        print("Headers: \(String(describing: headers))")
        print("Response: \($0)")
        print("=================================================================\n")
        accessory?.requestDidStop()
        if let data = try parseData($0, key: key) {
            return data
        } else {
            throw NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "返回数据中data为空"])
        }
        }.catchErrorWithComplete(handler: {
            accessory?.requestDidStop()
            UIApplication.shared.keyWindow?.noticeOnlyText($0.localizedDescription)
            if $0.code == 40001 {
                LoginCenter.default.forceLogin()
            }
        })
}

private func parseData(_ json: Any, key: String? = nil) throws -> Any? {
    
    guard let json = json as? [String: Any] else {
        throw NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "返回的数据不是json格式"])
    }
    
    guard let errorCode = json["error_code"] as? Int else {
        throw NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "返回的错误吗不是Int类型"])
    }
    
    guard errorCode == 0 else {
        let errorMessage = json["error_message"] as? String
        throw NSError(domain: "NetworkService", code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? "返回的数据格式没有按照约定返回"])
    }

    let data: Any? = {
        let data = json["data"]
        if let key = key {
            return (data as AnyObject).value(forKeyPath: key)
        }
        return data
    }()
    
    return data
}
