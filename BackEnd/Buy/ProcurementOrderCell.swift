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
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var payWayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    
    private var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    var order: (Bool, ProcurementOrder)! {
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
            dateLabel.text = order.1.createDate?.toString(by: "yyyy-MM-dd HH:mm:ss")
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

    static func cellHeight(order: (isXiaji: Bool, order: ProcurementOrder)) -> CGFloat {
        if !order.isXiaji && order.order.state == .notPay {
            return 209
        } else {
            return 167
        }
    }
    
    @IBAction func clickPayButton(sender: Any) {
        let id = order.1.id
        payForProcurementOrder(id: id, in: parentViewController!, disposeBag: disposeBag)
    }
}
