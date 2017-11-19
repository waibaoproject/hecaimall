//
//  SaleManViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension
import SegmentedControl
import WebImage
import IQKeyboardManagerSwift

class SaleManViewController: UITableViewController, FromBackendStoryboard {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["APP二维码", "微信二维码"]
            
            let normalColor = UIColor(hex: 0x595757)!
            let selectedColor = UIColor(hex: 0xD22222)!
            
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalColor], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
            
            segmentedControl.segmentBackgroundView = {
                Slider(isSelected: $0, color: selectedColor, size: CGSize(width: 0, height: 2))
            }
            
            segmentedControl.didSelect = { [unowned self] in
                self.qrCodeImageView.web.setImage(with: $0 == 0 ? self.saleMan?.appQrCode: self.saleMan?.wechatQrCode)
            }
        }
    }
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var saleMan: Salesman?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "业务员资料"
        tableView.keyboardDismissMode = .onDrag
        nameTextField.text = saleMan?.name
        phoneTextField.text = saleMan?.phone
        companyTextField.text = saleMan?.distributors
        qrCodeImageView.web.setImage(with: saleMan?.appQrCode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }

    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            guard let id = saleMan?.id else {return}
            let controller = MyDeliveryViewController()
            controller.api = NextableAPIPath(path: "/salesmans/\(id)/orders")
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func clickSaveButton(sender: Any) {
        guard let id = saleMan?.id else {return}
        guard let name = nameTextField.text, !name.isBlankString else {
            noticeOnlyText("业务员名称不能为空")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isBlankString else {
            noticeOnlyText("请填写手机号码")
            return
        }
        
        guard phone.hasPrefix("1"), phone.length == 11 else {
            noticeOnlyText("请输入正确的手机号码")
            return
        }
        
        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .put, path: "/salesmans/\(id)", parameters: ["name": name, "phone": phone])
        
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: Salesman) in
            self?.noticeOnlyText("保存成功")
        }).disposed(by: disposeBag)
    }
    
    @IBAction func clickDeleteButton(sender: Any) {
        guard let id = saleMan?.id else {return}
        let loading = LoadingAccessory(view: view)
        let api = APIPath(method: .delete, path: "/salesmans/\(id)")
        responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: { [weak self] in
            self?.noticeOnlyText("删除成功")
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}

