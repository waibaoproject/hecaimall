//
//  XiajiDeliveryCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class XiajiDeliveryCell: UITableViewCell, NibReusable {

    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var principalLabel: UILabel!
    
    static let cellHeight: CGFloat = 130
    
    var partner: Partner! {
        didSet {
            let address = LocationManager.shared.address(withCode: partner.districtCode)
            areaLabel.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            partnerNameLabel.text = "合伙人：\(partner.name)"
            principalLabel.text = "负责人：\(partner.principal)"
        }
    }

    @IBAction func clickLookOrderButton(sender: Any) {
        let controller1 = MyDeliveryViewController()
        controller1.api = NextableAPIPath(path: "/partners/\(self.partner?.id ?? "")/orders")
        controller1.title = "订单列表"
        parentViewController?.navigationController?.pushViewController(controller1, animated: true)
    }
}
