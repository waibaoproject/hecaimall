//
//  Location.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/10.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation

struct Province {
    
    let code: UInt
    let name: String
    
    init(code: UInt, name: String) {
        self.code = code
        self.name = name
    }
}

struct City {
    
    let code: UInt
    let name: String
    
    init(code: UInt, name: String) {
        self.code = code
        self.name = name
    }
}

struct District {
    
    let code: UInt
    let name: String
}

extension Province {

    var cities: [City] {
        return LocationManager.shared.cities.filter { return $0.code / 10000 == code / 10000 }
    }
}

extension City {

    var districts: [District] {
        return LocationManager.shared.districts.filter { return $0.code / 100 == code / 100 }
    }
}
