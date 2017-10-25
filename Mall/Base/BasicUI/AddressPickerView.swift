//
//  AddressPickerView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/7.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class AddressPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, NibLoadable, AsPicker {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var didSelectCode: ((UInt) -> Void)?
    
    private lazy var provinces: [Province] = {
        return LocationManager.shared.provinces
    }()
    
    private lazy var selectedProvince: Province = {
        return provinces.first!
    }()
    
    private lazy var selectedCity: City? = {
        let cities = selectedProvince.cities
        return cities.first
    }()
    
    private lazy var selectedDistrict: District? = {
        return selectedCity?.districts.first
    }()
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return provinces.count
        } else if component == 1 {
            return selectedProvince.cities.count
        } else {
            return selectedCity?.districts.count ?? 0
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return provinces[row].name
        } else if component == 1 {
            return selectedProvince.cities[row].name
        } else {
            return selectedCity?.districts[row].name ?? ""
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedProvince = provinces[row]
            selectedCity = selectedProvince.cities.first
            selectedDistrict = selectedCity?.districts.first
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else if component == 1 {
            selectedCity = selectedProvince.cities[row]
            selectedDistrict = selectedCity?.districts.first
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else {
            selectedDistrict = selectedCity?.districts[row]
        }
        let code: UInt = {
            if let selectedDistrict = selectedDistrict {
                return selectedDistrict.code
            } else if let selectedCity = selectedCity {
                return selectedCity.code
            } else {
                return selectedProvince.code
            }
        }()
        didSelectCode?(code)
        pickerView.reloadAllComponents()
    }
}
