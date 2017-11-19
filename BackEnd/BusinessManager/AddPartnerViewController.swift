//
//  AddPartnerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/17.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class AddPartnerViewController: UIViewController, FromBackendStoryboard {
    
    private let disposeBag = DisposeBag()

    private lazy var controller: AddPartnerContentViewController = {
        return self.childViewControllers.first as! AddPartnerContentViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加合伙人"
    }

    @IBAction func clickAddButton(sender: Any) {
        guard let typeId = controller.typeId else {
            view.toast("请选择合伙人类型")
            return
        }
        
        guard let name = controller.name, !name.isBlankString else {
            view.toast("请填写合伙人名称")
            return
        }

        guard let principal = controller.principal, !principal.isBlankString else {
            view.toast("请填写负责人")
            return
        }

        guard let image = controller.image else {
            view.toast("请选择图标")
            return
        }

        guard let phone = controller.phone, !phone.isBlankString else {
            view.toast("请填写手机号码")
            return
        }
        
        guard phone.hasPrefix("1"), phone.length == 11 else {
            view.toast("请输入正确的手机号码")
            return
        }

        guard let account = controller.account, !account.isBlankString else {
            view.toast("请填写账号（手机号码）")
            return
        }
        
        guard account.hasPrefix("1"), account.length == 11 else {
            view.toast("请输入正确的账号(手机号码)")
            return
        }

        guard let password = controller.password, !password.isBlankString else {
            view.toast("请填写密码")
            return
        }

        guard password.length >= 6 else {
            view.toast("密码长度必须大于6")
            return
        }
        
        guard controller.areaId != 0 else {
            view.toast("请选择地区")
            return
        }
        
        guard let address = controller.address else {
            view.toast("请填写详细地址")
            return
        }
        
        let code = image.data?.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .post, path: "/partners", parameters: [
            "type_id": typeId,
            "name": name,
            "principal": principal,
            "icon": code!,
            "phone": phone,
            "account": account,
            "password": password,
            "area": controller.areaId,
            "address": address
            ])
        responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: { [weak self] in
            self?.view.toast("添加合伙人成功")
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
