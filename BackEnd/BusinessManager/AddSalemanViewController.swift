//
//  AddSalemanViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension
import IQKeyboardManagerSwift

class AddSalemanViewController: UITableViewController, FromBackendStoryboard {
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var didAddSaleman: (()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加业务员"
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

    
    @IBAction func clickAddButton(sender: Any) {
        view.endEditing(true)

        guard let name = nameTextField.text, !name.isBlankString else {
            view.toast("请填写业务员")
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
        
        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .post, path: "/salesmans", parameters: [
            "name": name,
            "phone": phone])
        responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: { [weak self] in
            self?.view.toast("添加业务员成功")
            self?.didAddSaleman?()
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
