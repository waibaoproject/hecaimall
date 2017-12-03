//
//  ProfileViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/11.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import FoundationExtension
import RxSwift
import DKImagePickerController
import IQKeyboardManagerSwift

extension UIImage {
    public var data: Data? {
        if let data = UIImageJPEGRepresentation(self, 1.0) {
            return data
        } else {
            return UIImagePNGRepresentation(self)
        }
    }
}


class ProfileViewController: UITableViewController, FromMyStoryboard {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UITextField!
    @IBOutlet weak var birthdayLabel: UITextField!
    @IBOutlet weak var sexLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    
    private var user: User!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    private func reloadData() {
        
        avatarImageView.web.setImage(with: user.avatar)
        nicknameLabel.text = user.nickname
        birthdayLabel.text = user.birthdate?.toString(by: "yyyy-MM-dd")
        sexLabel.text = user.isMale ? "男": "女"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        if user.cityCode == 0  {
            locationLabel.text = nil
        } else {
            let address = LocationManager.shared.address(withCode: user.cityCode)
            locationLabel.text = [address.province?.name, address.city?.name].flatMap{$0}.joined(separator: " ")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos

            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                guard let asset = assets.first else {return}
                asset.fetchFullScreenImage(false, completeBlock: { (image, info) in
                    if let code = image?.wxCompress().data?.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        self.modifyUser(parameters: ["avatar": code])
                    }
                })
                print(assets)
            }
            
            pickerController.singleSelect = true
            
            present(pickerController, animated: true, completion: nil)
            
            
        } else if indexPath.section == 1 {
            let controller = TextEditViewController.instantiate()
            controller.title = "昵称"
            controller.text = user.nickname
            controller.didSave = { [weak self] nickname in
                guard let `self` = self else {return}
                self.navigationController?.popViewController(animated: true)
                self.modifyUser(parameters: ["nickname": nickname])
            }
            navigationController?.pushViewController(controller, animated: true)
            
        } else if indexPath.section == 2 {
            
            let view = DatePickerView()
            view.currentDate = user.birthdate
            view.didConfirm = {
                self.modifyUser(parameters: ["birthdate": $0.timeIntervalSince1970])
                view.dismiss()
            }
            view.showAsPicker(height: 250)
            
        } else if indexPath.section == 3 {
            
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "男", style: .default, handler: { (_) in
                self.modifyUser(parameters: ["is_male": 1])
            }))
            controller.addAction(UIAlertAction(title: "女", style: .default, handler: { (_) in
                self.modifyUser(parameters: ["is_male": 0])
            }))
            controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                
            }))
            present(controller, animated: true, completion: nil)
            
        } else if indexPath.section == 4 {
            
            let controller = TextEditViewController.instantiate()
            controller.title = "联系电话"
            controller.text = user.phone
            controller.keyboardType = .numberPad
            controller.didSave = { [weak self] phone in
                guard let `self` = self else {return}
                
                guard !phone.isBlankString else {
                    UIApplication.shared.keyWindow?.toast("请填写手机号码")
                    return
                }
                
                guard phone.hasPrefix("1"), phone.length == 11 else {
                    UIApplication.shared.keyWindow?.toast("请输入正确的手机号码")
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
                self.modifyUser(parameters: ["phone": phone])
            }
            navigationController?.pushViewController(controller, animated: true)
            
        } else if indexPath.section == 5 {
            
            let controller = TextEditViewController.instantiate()
            controller.title = "邮箱地址"
            controller.text = user.email
            controller.didSave = { [weak self] email in
                guard let `self` = self else {return}
                self.navigationController?.popViewController(animated: true)
                self.modifyUser(parameters: ["email": email])
            }
            navigationController?.pushViewController(controller, animated: true)
            
        } else {
            
            let view = AddressPickerView.loadFromNib()
            view.showAsPicker(height: 250)
            view.didSelectCode = { [weak self] in
                guard let `self` = self else {return}
                self.modifyUser(parameters: ["city_code": $0])
            }
        }
    }
    
    private func loadUser() {
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: APIPath(path: "/user")).response(accessory: loading)
            .subscribe(onNext: { [weak self] (data: User) in
                guard let `self` = self else {return}
                self.user = data
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func modifyUser(parameters: [String: Any]) {
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: APIPath(method: .put, path: "/user", parameters: parameters))
        .response(accessory: loading)
            .subscribe(onNext: { (data: User) in
                self.user = data
                self.reloadData()
            })
        .disposed(by: disposeBag)
    }
}
