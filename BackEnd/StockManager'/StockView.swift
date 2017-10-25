//
//  StockView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import SnapKit

class StockView: UIView, NibLoadable {
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var warehouse: Warehouse? {
        didSet {
            productNameLabel.text = warehouse?.product?.name
            totalCountLabel.text = "\(warehouse?.stock ?? 0) 件"
        }
    }
    
    private var areaId: UInt = 0
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func hide() {
        removeFromSuperview()
    }
    
    @IBAction func clickAreaSelectButton(sender: Any) {
        // TODO:

    }
    
    @IBAction func clickBackgroundButton(sender: Any) {
        hide()
    }
    
    @IBAction func clickConfirnButton(sender: Any) {
        
        guard let warehourse = warehouse else {return}
        
        guard let count = countTextField.text?.intValue else {
            noticeOnlyText("请填写提货数量")
            return
        }
        
        guard count > warehourse.stock else {
            noticeOnlyText("提货数量不能大于虚拟仓库存")
            return
        }
        
        guard let name = nameTextField.text, !name.isBlankString else {
            noticeOnlyText("收货人")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isBlankString else {
            noticeOnlyText("请填写联系电话")
            return
        }
        
        guard phone.hasPrefix("1"), phone.length == 11 else {
            noticeOnlyText("请输入正确的联系电话")
            return
        }
        
        guard areaId != 0 else {
            noticeOnlyText("请选择地区")
            return
        }
        
        guard let address = addressTextField.text else {
            noticeOnlyText("请填写详细地址")
            return
        }
        
        let loading = LoadingAccessory(view: self)
        let api = APIPath(method: .post, path: "/warehouses/\(warehourse.id)/extract", parameters: [
            "count": count,
            "name": name,
            "phone": phone,
            "district_code": areaId,
            "address": address])
        responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: { [weak self] in
            self?.noticeOnlyText("提取产品成功")
            self?.hide()
        }).disposed(by: disposeBag)
    }
}
