//
//  LocationManager.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/10.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import Alamofire
// 数据参考：http://www.stats.gov.cn/tjsj/tjbz/xzqhdm/201703/t20170310_1471429.html
// 数据来源：https://github.com/mumuy/data_location

class LocationManager {
    
    static let shared = LocationManager()
    private init() {
        loadFromLocal()
        loadFromServer()
    }
    
    public fileprivate(set) var provinces: [Province] = []
    public fileprivate(set) var cities: [City] = []
    public fileprivate(set) var districts: [District] = []
}

extension LocationManager {
    
    func province(withCode code: UInt) -> Province? {
        return provinces.filter {
            $0.code / 10000 == code / 10000
        }.first
    }
    
    func city(withCode code: UInt) -> City? {
        return cities.filter {
            $0.code / 100 == code / 100
            }.first
    }
    
    func district(withCode code: UInt) -> District? {
        return districts.filter {
            $0.code == code
            }.first
    }

    func address(withCode code: UInt) -> Address {
        let province = self.province(withCode: code)
        let city = self.city(withCode: code)
        let district = self.district(withCode: code)
        return Address(province: province, city: city, district: district)
    }
    
    private func loadFromLocal() {
        
        guard let fileURL = Bundle.main.url(forResource: "china-location", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: String] else { return }
        resolve(json: json)
    }
    
    private func resolve(json: [String: String]) {
        guard json.count > 0 else {return}
        provinces.removeAll()
        cities.removeAll()
        districts.removeAll()
        json.forEach {
            guard let code = UInt($0.key), code > 100000 else {
                return
            }
            let name = $0.value
            
            if code % 10000 == 0 {
                provinces.append(Province(code: code, name: name))
            } else if code % 100 == 0 {
                cities.append(City(code: code, name: name))
            } else {
                districts.append(District(code: code, name: name))
            }
        }
    }
    
    private func loadFromServer() {
        request("http://gc.ucardpro.com/v1/config/location").responseJSON { (response) in
            switch response.result {
            case let .success(value):
                if let value = value as? [String: String] {
                    self.resolve(json: value)
                }
            case let .failure(error):
                print("地址获取失败(\(error.localizedDescription)")
            }
        }
    }
}
