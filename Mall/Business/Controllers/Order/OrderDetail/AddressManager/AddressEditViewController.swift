//
//  AddressEditViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/7.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class AddressEditViewController: UITableViewController, FromOrderStoryboard {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var detailTextField: PlaceholderTextView!
    
    var receiver: Receiver = Receiver()
    
    var didSave: ((Receiver) -> Void)?
    
    private let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    func reloadData() {
        nameTextField.text = receiver.name.isBlankString ? nil : receiver.name
        phoneTextField.text = receiver.phone.isBlankString ? nil : receiver.phone
        let address: Address = LocationManager.shared.address(withCode: receiver.districtCode)
        let addressString = [address.province?.name, address.city?.name, address.district?.name].flatMap { $0 }.joined(separator: " ")
        addressTextField.text = addressString.isBlankString ? nil : addressString
        detailTextField.text = receiver.detail.isBlankString ? nil : receiver.detail
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let view = AddressPickerView.loadFromNib()
            view.showAsPicker(height: 250)
            view.didSelectCode = { [weak self] in
                guard let `self` = self else {return}
                self.receiver.districtCode = $0
                self.reloadData()
            }
        }
    }
    
    @IBAction func clickSaveButton(sender: Any) {
        receiver.name = nameTextField.text ?? ""
        receiver.phone = phoneTextField.text ?? ""
        // TODO:
//        receiver.districtCode = 0
        receiver.detail = detailTextField.text
        
        guard !receiver.name.isBlankString else {
            view.noticeOnlyText("请输入收货人姓名")
            return
        }
        
        guard !receiver.phone.isBlankString else {
            view.noticeOnlyText("请输入联系电话")
            return
        }
        
        guard receiver.phone.hasPrefix("1"), receiver.phone.length == 11 else {
            view.noticeOnlyText("联系电话不正确，请重新填写")
            return
        }
        
        guard receiver.districtCode != 0 else {
            view.noticeOnlyText("请输入所在地区")
            return
        }
        
        guard !receiver.detail.isBlankString else {
            view.noticeOnlyText("请输入详细地址")
            return
        }
        
        let parameters: [String: Any] = ["name": receiver.name,
                                         "phone": receiver.phone,
                                         "district_code": receiver.districtCode,
                                         "detail": receiver.detail,
                                         "is_default": receiver.isDefault]
        
        let accessory = LoadingAccessory(view: view)
        
        
        let api: APIPath = {
            if receiver.id.isBlankString {
                return APIPath(method: .post, path: "/user/receivers", parameters: parameters)
            } else {
                return APIPath(method: .put, path: "/user/receivers/id/\(receiver.id)", parameters: parameters)
            }
        }()

        DefaultDataSource(api: api).response(accessory: accessory).subscribe(onNext: { [weak self] (receiver: Receiver) in
            guard let `self` = self else {return}
            self.receiver = receiver
            self.reloadData()
            self.didSave?(receiver)
        })
            .disposed(by: disposeBag)
    }
}
