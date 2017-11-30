//
//  OfflineApplyViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension
import IQKeyboardManagerSwift

class OfflineApplyViewController: UITableViewController, FromBuyStoryboard {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verifyCodeButton: UIButton!
    
    private let disposeBag = DisposeBag()

    private var products: [Product] = []
    
    private var phone: String?
    
    private var selectedProduct: Product? {
        didSet {
            productNameLabel.text = selectedProduct?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        DefaultArrayDataSource(api: APIPath(path: "/procurement/order/products")).response(accessory: nil).subscribe(onNext: { [weak self] (data: [Product]) in
            guard let `self` = self else {return}
            self.products = data
        }).disposed(by: disposeBag)
        
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

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let view = ItemsSelectionView()
            view.items = products.flatMap({ $0.name })
            view.selected = { [weak self] (value, index) in
                guard let `self` = self else {return}
                self.selectedProduct = self.products[index]
            }
            view.showAsPicker(height: 250)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
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
        view.endEditing(true)

        guard let product = selectedProduct else {
            view.toast("请选择商品")
            return
        }
        
        guard let count = countTextField.text?.intValue, count > 0 else {
            view.toast("请输入购买数量")
            return
        }
        
        guard let verifyCode = phoneTextField.text, !verifyCode.isBlankString else {
            view.toast("请输入验证码")
            return
        }

        
        let id = product.id
        let time = Date().timeIntervalSince1970
        let key = "t5e31fd03vcq76"
        let md5 = MD5("\(id)\(verifyCode)\(count)")
        let secret = MD5("\(md5)\(time)\(key)")
        
        let api = APIPath(method: .post, path: "/offline/procurement/orders", parameters: ["id": id, "verify_code": verifyCode, "stock": count, "time": time, /*"key": key,*/ "secret": secret])
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            self.view.toast("申请成功")
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
}
