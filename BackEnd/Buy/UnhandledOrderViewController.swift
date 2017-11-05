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
        productNameLabel.text = order?.productName
        let stock = order?.stock ?? 0
        countLabel.text = stock < 0 ? "无限" : String(stock)
        DefaultDataSource(api: APIPath(path: "/user")).response(accessory: nil)
            .subscribe(onNext: { [weak self] (data: User) in
                guard let `self` = self else {return}
                self.phone = data.phone
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func clickVerifyCodeButton(sender: Any) {
        guard let phone = phone else {
            self.noticeOnlyText("账号有问题，请退出该页面后再重试")
            return
        }
        responseVoid(accessory: nil, urlRequest: APIPath(path: "/procurement/orders/verifyCode", parameters: ["mobile": phone, "type": "procurement"])).subscribe(onNext: { [weak self] in
            guard let `self` = self else {return}
            self.noticeOnlyText("手机验证码已发送，请查收")
            self.verifyCodeButton.isEnabled = false
            self.counter.start(count: 30)
        }).disposed(by: disposeBag)
    }

    @IBAction func clickApplyButton(sender: Any) {
        guard let id = order?.id else {return}
        let verifyCode = phoneTextField.text ?? ""
        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .put, path: "/procurement/orders/\(id)", parameters: ["state": 60, "verify_code": verifyCode])
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            self.noticeOnlyText("订单已通过")
            self.didHandle?()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func clickRejectButton(sender: Any) {
        guard let id = order?.id else {return}
        let verifyCode = phoneTextField.text ?? ""
        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .put, path: "/procurement/orders/\(id)", parameters: ["state": 70, "verify_code": verifyCode])
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            self.noticeOnlyText("订单已驳回")
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
