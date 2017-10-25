//
//  PartnerCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class PartnerCell: UITableViewCell, Reusable {
    @IBOutlet weak var loactionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fuzerenLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var partner: Partner! {
        didSet {
            let address = LocationManager.shared.address(withCode: partner.districtCode)
            loactionLabel.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            nameLabel.text = partner.name
            fuzerenLabel.text = partner.principal
            phoneLabel.text = partner.phone
            addressLabel.text = partner.address
        }
    }
}
