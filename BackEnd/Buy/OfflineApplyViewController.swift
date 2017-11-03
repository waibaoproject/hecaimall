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

class OfflineApplyViewController: UITableViewController, FromBuyStoryboard {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verifyCodeButton: UIButton!
    
    private let disposeBag = DisposeBag()

    private var products: [Product] = []
    
    private var phone: String?
    
    private var selectedProduct: Product? {
        didSet {
            productNameLabel.text = selectedProduct?.name
            let count = selectedProduct?.stock ?? 0
            if count < 0 {
                countLabel.text = "无限"
            } else {
                countLabel.text = String(count)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        DefaultArrayDataSource(api: APIPath(path: "/procurement/order/products")).response(accessory: nil).subscribe(onNext: { [weak self] (data: [Product]) in
            guard let `self` = self else {return}
            self.products = data
        }).disposed(by: disposeBag)
        
        DefaultDataSource(api: APIPath(path: "/user")).response(accessory: nil)
            .subscribe(onNext: { [weak self] (data: User) in
                guard let `self` = self else {return}
                self.phone = data.phone
            })
            .disposed(by: disposeBag)
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
        guard let product = selectedProduct else {
            self.noticeOnlyText("请选择商品")
            return
        }
        
        let id = product.id
        let verifyCode = phoneTextField.text ?? ""
        let stock = product.stock
        
        let api = APIPath(method: .post, path: "/offline/procurement/orders", parameters: ["id": id, "verify_code": verifyCode, "stock": stock])
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            self.noticeOnlyText("申请成功")
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
