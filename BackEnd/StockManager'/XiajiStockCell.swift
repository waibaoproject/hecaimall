//
//  XiajiStockCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

import Reusable

class  XiajiStockCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var principalLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var partner: Partner! {
        didSet {
            let address = LocationManager.shared.address(withCode: partner.districtCode)
            let text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            let attributedString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0xF8B62D)!])
            let result = NSMutableAttributedString(string: "地区: ")
            result.append(attributedString)
            areaLabel.attributedText = result
            partnerLabel.text = partner.name
            principalLabel.text = partner.principal
            phoneLabel.text = partner.phone
        }
    }
    
    @IBAction func clickCheckoutButton(sender: Any) {
    
        let controller1 = MyStockViewController.instantiate()
        controller1.api = NextableAPIPath(path: "/partners/\(self.partner?.id ?? "")/warehouses")
        controller1.hideCheckoutButtons = true
        parentViewController?.navigationController?.pushViewController(controller1, animated: true)
    }
}
