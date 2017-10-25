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
            areaLabel.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            partnerLabel.text = partner.name
            principalLabel.text = partner.principal
            phoneLabel.text = partner.phone
        }
    }
    
    @IBAction func clickCheckoutButton(sender: Any) {
        
        
    }
}
