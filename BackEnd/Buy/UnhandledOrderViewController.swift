//
//  UnhandledOrderViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/5.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension
import IQKeyboardManagerSwift

class UnhandledOrderViewController: UITableViewController, FromBuyStoryboard {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verifyCodeButton: UIButton!
    
    var order: ProcurementOrder?
    
    var didHandle: (()->Void)?
    
    private let disposeBag = DisposeBag()

    private var phone: String?
    
    private lazy var counter: DownCounter = { [weak self] in
        let counter = DownCounter(step: 1, target: self)
        counter.down = {
            self?.verifyCodeButton.isEnabled = false
            self?.verifyCodeButton.setTitle("\($0)", for: .normal)
        }
        counter.done = {
            self?.verifyCodeButton.setTitle("获取验证码", for: .normal)
            self?.verifyCodeButton.isEnabled = true
        }
        return counter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "未处理订单"
        tableView.keyboardDismissMode = .onDrag
        productNameLabel.text = order?.productName
        let stock = order?.count ?? 0
        countLabel.text = stock < 0 ? "无限" : String(stock)
        DefaultDataSource(api: APIPath(path: "/user/partner")).response(accessory: nil)
            .subscribe(onNext: { [weak self] (data: Partner) in
                guard let `self` = self else {return}
                self.phone = data.phone
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    @IBAction func clickVerifyCodeButton(sender: Any) {
        view.endEditing(true)

        guard let phone = phone else {
            view.toast("账号有问题，请退出该页面后再重试")
            return
        }
        responseVoid(accessory: nil, urlRequest: APIPath(path: "/procurement/orders/verifyCode", parameters: ["mobile": phone, "type": "procurement"])).subscribe(onNext: { [weak self] in
            guard let `self` = self else {return}
            self.view.toast("手机验证码已发送，请查收")
            self.verifyCodeButton.isEnabled = false
            self.counter.start(count: 60)
        }).disposed(by: disposeBag)
    }

    @IBAction func clickApplyButton(sender: Any) {
        guard let id = order?.id else {return}
        view.endEditing(true)

        let verifyCode = phoneTextField.text ?? ""
        let loading = LoadingAccessory(view: view)
        let state = 60
        let key = "t5e31fd03vcq76"
        let time = Int(Date().timeIntervalSince1970)
        let md5 = MD5("\(state)\(verifyCode)").lowercased()
        let secret = MD5("\(md5)\(time)\(key)").lowercased()
        let api = APIPath(method: .put, path: "/procurement/orders/\(id)", parameters: ["state": state, "verify_code": verifyCode, "time": time, /*"key": key,*/ "secret": secret])
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            self.view.toast("订单已通过")
            self.didHandle?()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func clickRejectButton(sender: Any) {
        guard let id = order?.id else {return}
        view.endEditing(true)

        let verifyCode = phoneTextField.text ?? ""
        let loading = LoadingAccessory(view: view)
        let state = 70
        let key = "t5e31fd03vcq76"
        let time = Int(Date().timeIntervalSince1970)
        let md5 = MD5("\(state)\(verifyCode)").lowercased()
        let secret = MD5("\(md5)\(time)\(key)").lowercased()

        let api = APIPath(method: .put, path: "/procurement/orders/\(id)", parameters: ["state": state, "verify_code": verifyCode, "time": time, /*"key": key,*/ "secret": secret])
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            self.view.toast("订单已驳回")
            self.didHandle?()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
}
