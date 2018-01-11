//
//  ProcurementOrderCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class ProcurementOrderCell: UITableViewCell, Reusable {
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var payWayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var receiverPhoneLabel: UILabel!
    @IBOutlet weak var receiverDistrictLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var contentHolderViewHeight: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    var order: (Bool, ProcurementOrder, MerchantType)! {
        didSet {
            orderNumberLabel.text = "申请单号: \(order?.1.orderNumber ?? "")"
            if order.0 {
                companyLabel.text = "下级: \((order.1.applicant ?? ""))"
            } else {
                companyLabel.text = "上级: \((order.1.superior ?? ""))"
            }
//            companyLabel.text = (order.0 ? "下级: ": "上级: ") + (order.1.superior ?? "")
            productLabel.text = "产品: \(order.1.productName ?? "")"
            countLabel.text = "数量: \(order.1.count)"
            payWayLabel.text = "支付方式: " + (order.1.payType ?? "")
            let date = order.1.createDate?.toString(by: "yyyy-MM-dd HH:mm:ss")
            dateLabel.text = "日期: \(date)"
            
            
            let isHidden = !(order.2 == MerchantType.base)
            receiverNameLabel.text = "收货人: \(order.1.receiver?.name ?? "")"
            receiverNameLabel.isHidden = isHidden
            receiverPhoneLabel.text = "联系电话: \(order.1.receiver?.phone ?? "")"
            receiverPhoneLabel.isHidden = isHidden
            let address = LocationManager.shared.address(withCode: order.1.receiver?.districtCode ?? 0)
            let region = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            receiverDistrictLabel.text = "所在地区: \(region)"
            receiverDistrictLabel.isHidden = isHidden
            addressLabel.text = "详细地址: \(order.1.receiver?.detail ?? "")"
            addressLabel.isHidden = isHidden
            
            contentHolderViewHeight.constant = (order.2 == .base ? 140 + 23 * 4 : 140)
            
            switch order.1.state {
            case .notPay:
                stateImageView.image = UIImage(named: "not_pay")
            case .paid:
                stateImageView.image = UIImage(named: "paid")
            case .waitForProcess:
                stateImageView.image = UIImage(named: "not_handle")
            case .passed:
                stateImageView.image = UIImage(named: "passed")
            case .rejected:
                stateImageView.image = UIImage(named: "rejected")
            }
        }
    }

    static func cellHeight(order: (isXiaji: Bool, order: ProcurementOrder, merchantType: MerchantType)) -> CGFloat {

        var height: CGFloat = 0
        if !order.isXiaji && order.order.state == .notPay {
            height = 209
        } else {
            height = 167
        }

        if order.merchantType == .base {
            height += 23 * 4
        }
        return height
    }
    
    @IBAction func clickPayButton(sender: Any) {
        let id = order.1.id
        payForProcurementOrder(id: id, in: parentViewController!, disposeBag: disposeBag)
    }
}
