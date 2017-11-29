//
//  LoginViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import GearNetwork
import FoundationExtension
import IQKeyboardManagerSwift

class LoginViewController: UITableViewController, FromMyStoryboard {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var getVerifyCodeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var didLogin: ((String) -> Void)?
    
    private lazy var counter: DownCounter = { [weak self] in
        let counter = DownCounter(step: 1, target: self)
        counter.down = {
            self?.getVerifyCodeButton.isEnabled = false
            self?.getVerifyCodeButton.setTitle("\($0)", for: .normal)
        }
        counter.done = {
            self?.getVerifyCodeButton.setTitle("获取验证码", for: .normal)
            self?.getVerifyCodeButton.isEnabled = true
        }
        return counter
    }()

    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    @IBAction func clickGetVerifyCodeButton(sender: Any) {
        view.endEditing(true)

        guard let phone = phoneTextField.text else {
            view.toast("请输入手机号码")
            return
        }
        
        guard !phone.isBlankString else {
            view.toast("请输入手机号码")
            return
        }
        
        guard phone.hasPrefix("1") && phone.length == 11 else {
            view.toast("请输入正确的手机号码")
            return
        }
        
        let api = APIPath(path: "/login/verifyCode", parameters: ["mobile": phone])
        
        responseVoid(accessory: LoadingAccessory(view: view), urlRequest: api).subscribe(onNext: {
            self.view.toast("手机验证码已发送，请查收")
            self.getVerifyCodeButton.isEnabled = false
            self.counter.start(count: 60)
        })
                    .disposed(by: disposeBag)

    }
    
    @IBAction func clickLoginButton(sender: Any) {
        view.endEditing(true)

        guard let phone = phoneTextField.text else {
            view.toast("请输入手机号码")
            return
        }
        
        guard !phone.isBlankString else {
            view.toast("请输入手机号码")
            return
        }
        
        guard phone.hasPrefix("1") && phone.length == 11 else {
            view.toast("请输入正确的手机号码")
            return
        }

        guard let code = verifyCodeTextField.text else {
            view.toast("请输入验证码")
            return
        }
        
        let api = APIPath(method: .post, path: "/login/doLogin", parameters: ["mobile": phone, "verify_code": code])
        let accessory = LoadingAccessory(view: view, message: "登录中")
        DefaultDataSource(api: api).response(accessory: accessory, key: "access_token")
            .subscribe(onNext: { [weak self] (token: String) in
                guard let `self` = self else {return}
                self.didLogin?(token)
            })
            .disposed(by: disposeBag)
    }
}
