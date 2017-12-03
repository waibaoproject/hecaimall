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
    
    var didExtract: (()->Void)?
    
    func show() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.updateConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    @objc func keyboardFrameWillShow(sender: Notification) {
        guard let endFrame = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        var keyboardVisibleHeight: CGFloat {
            return UIScreen.main.bounds.height - endFrame.origin.y
        }
        
        self.snp.updateConstraints {
            $0.top.equalToSuperview().offset(-keyboardVisibleHeight - 20 + (bounds.height - 400) / 2)
        }
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }
    
    @objc func keyboardFrameWillHide(sender: Notification) {
        self.snp.updateConstraints {
            $0.top.equalToSuperview()
        }
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }
    
    func hide() {
        NotificationCenter.default.removeObserver(self)
        removeFromSuperview()
    }
    
    @IBAction func clickAreaSelectButton(sender: Any) {
        endEditing(true)
        let view = AddressPickerView.loadFromNib()
        view.showAsPicker(height: 250)
        view.didSelectCode = { [weak self] in
            guard let `self` = self else {return}
            self.areaId = $0
            let address = LocationManager.shared.address(withCode: $0)
            self.areaTextField.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
        }
    }
    
    @IBAction func clickBackgroundButton(sender: Any) {
        hide()
    }
    
    @IBAction func clickConfirnButton(sender: Any) {
        
        guard let warehourse = warehouse else {return}
        endEditing(true)

        guard let count = countTextField.text?.intValue else {
            toast("请填写提货数量")
            return
        }
        
        guard count <= warehourse.stock else {
            toast("提货数量不能大于虚拟仓库存")
            return
        }
        
        guard let name = nameTextField.text, !name.isBlankString else {
            toast("收货人")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isBlankString else {
            toast("请填写联系电话")
            return
        }
        
        guard phone.hasPrefix("1"), phone.length == 11 else {
            toast("请输入正确的联系电话")
            return
        }
        
        guard areaId != 0 else {
            toast("请选择地区")
            return
        }
        
        guard let address = addressTextField.text else {
            toast("请填写详细地址")
            return
        }
        
        let loading = LoadingAccessory(view: self)
        let time = Int(Date().timeIntervalSince1970)
        let key = "t5e31fd03vcq76"
        let md5 = MD5("\(count)\(name)\(phone)\(areaId)\(address)").lowercased()
        let secret = MD5("\(md5)\(time)\(key))").lowercased()
        let api = APIPath(method: .post, path: "/warehouses/\(warehourse.id)/extract", parameters: [
            "count": count,
            "name": name,
            "phone": phone,
            "district_code": areaId,
            "address": address,
            "time": time,
//            "key": key,
            "secret": secret
            ])
        
        responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: { [weak self] in
            self?.toast("提取产品成功")
            self?.didExtract?()
            self?.hide()
        }).disposed(by: disposeBag)
        
    }
}



