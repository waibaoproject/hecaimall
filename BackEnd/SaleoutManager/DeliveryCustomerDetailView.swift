//
//  DeliveryCustomerDetailView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/26.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import SnapKit

class DeliveryCustomerDetailView: UIView, NibLoadable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    var order: Order? {
        didSet {
            nameLabel.text = "联系人：" + (order?.receiver?.name ?? "")
            phoneLabel.text = "联系方式："  + (order?.receiver?.phone ?? "")
            let address = LocationManager.shared.address(withCode: order?.receiver?.districtCode ?? 0)
            areaLabel.text = "物流地址：" + [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
        }
    }

    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func hide() {
        removeFromSuperview()
    }

    @IBAction func clickConfirnButton(sender: Any) {
        hide()
    }
}
