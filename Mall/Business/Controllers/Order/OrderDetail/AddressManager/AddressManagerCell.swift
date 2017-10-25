//
//  AddressManagerCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/7.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class AddressManagerCell: UITableViewCell, Reusable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var isDefaultButton: UIButton!
    
    var receiver: Receiver! {
        didSet {
            nameLabel.text = receiver.name
            phoneLabel.text = receiver.phone
            let address = LocationManager.shared.address(withCode: receiver.districtCode)
            addressLabel.text = [address.province?.name, address.city?.name, address.district?.name, receiver.detail].flatMap({ $0 }).joined(separator: " ")
            isDefaultButton.isSelected = receiver.isDefault
        }
    }
    
    var didClickSelectReceiverButton: ((Receiver) -> Void)?
    var didClickDeleteReceiverButton: ((Receiver) -> Void)?
    var didClickEditReceiverButton: ((Receiver) -> Void)?
    
    @IBAction func clickSelectButton(sender: Any) {
        didClickSelectReceiverButton?(receiver)
    }
    
    @IBAction func clickEditButton(sender: Any) {
       didClickEditReceiverButton?(receiver)
    }
    
    @IBAction func clickDeleteButton(sender: Any) {
        didClickDeleteReceiverButton?(receiver)
    }
}
