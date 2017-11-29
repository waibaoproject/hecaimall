//
//  ProductServiceViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/29.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import FoundationExtension
import RxSwift

class ProductServiceViewController: UITableViewController, FromProductStoryboard {
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var remarkTextField: PlaceholderTextView!
    
    var productId: String = ""
    var productName: String?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "联系客服"
        productLabel.text = productName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    @IBAction func clickConfirmButton(sender: Any) {
        
        view.endEditing(true)
        
        guard let name = nameTextField.text, !name.isBlankString else {
            view.toast("请输入客户名称")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isBlankString else {
            view.toast("请填写手机号码")
            return
        }
        
        guard phone.hasPrefix("1"), phone.length == 11 else {
            view.toast("请输入正确的手机号码")
            return
        }
        
        guard let remark = remarkTextField.text, !remark.isBlankString else {
            view.toast("请输入问题留言")
            return
        }
        
        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .post, path: "/user/serviceProduct/id/\(productId)", parameters: [
            "truename": name,
            "phone": phone,
            "question": remark
            ])
        responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: { [weak self] in
            UIApplication.shared.keyWindow?.toast("问题已提交，稍后会有客服人员与您联系")
            self?.navigationController?.popViewController(animated: true)
        }).addDisposableTo(disposeBag)
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
