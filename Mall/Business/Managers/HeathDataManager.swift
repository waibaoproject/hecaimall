//
//  HeathDataManager.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/12.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import Alamofire

class HeathDataManager {
    
    static let shared = HeathDataManager()
    
    var data: [String: [String]] = [:]
    
    private init() {
        
        request("http://gc.ucardpro.com/v1/config/health").responseJSON { (response) in
            switch response.result {
            case let .success(value):
                if let originData = (value as? [String: Any])?["data"] as? [String: String] {
                    originData.forEach({ (key, value) in
                        self.data[key] = value.components(separatedBy: ",")
                    })
                }
            case let .failure(error):
                print("load heath data failed: \(error.localizedDescription)")
            }
        }
    }
}
