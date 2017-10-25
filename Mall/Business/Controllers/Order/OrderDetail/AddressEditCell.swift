//
//  AddressEditCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class AddressEditCell: UITableViewCell, Reusable {

    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var receiverPhoneLabel: UILabel!
    @IBOutlet weak var receiverAddressLabel: UILabel!

    var receiver: Receiver? {
        didSet {
            if let receiver = receiver {
                let address: Address = LocationManager.shared.address(withCode: receiver.districtCode)
                receiverNameLabel.text = receiver.name
                receiverPhoneLabel.text = receiver.phone
                receiverAddressLabel.text = [address.province?.name, address.city?.name, address.district?.name, receiver.detail].flatMap { $0 }.joined(separator: " ") 
            } else {
                receiverNameLabel.text = "收货人：请填写"
                receiverPhoneLabel.text = nil
                receiverAddressLabel.text = "收货地址：请填写"
            }
        }
    }
}
