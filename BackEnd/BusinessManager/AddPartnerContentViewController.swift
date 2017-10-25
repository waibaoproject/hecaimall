//
//  AddPartnerContentViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/22.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DKImagePickerController

class AddPartnerContentViewController: UITableViewController, FromBackendStoryboard {
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var principalTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var addressTextField: PlaceholderTextView!
    
    var typeId: String?
    
    var name: String? {
        return nameTextField.text
    }
    
    var principal: String? {
        return principalTextField.text
    }
    
    var image: UIImage?
    
    var phone: String? {
        return phoneTextField.text
    }

    var account: String? {
        return accountTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    var areaId: UInt = 0
    
    var address: String? {
        return addressTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            view.items = PartnerTypesManager.shared.items.map {$0.name}
            view.selected = { [weak self] (value, index) in
                guard let `self` = self else {return}
                let partnerType = PartnerTypesManager.shared.items[index]
                self.typeId = partnerType.id
                self.typeTextField.text = partnerType.name
            }
            view.showAsPicker(height: 250)
            
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            
        } else if indexPath.section == 3 {
            
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                guard let asset = assets.first else {return}
                asset.fetchFullScreenImage(false, completeBlock: { (image, info) in
                    self.image = image?.wxCompress()
                    self.iconImageView.image = image
                })
            }
            
            pickerController.singleSelect = true
            
            present(pickerController, animated: true, completion: nil)
            
        } else if indexPath.section == 4 {
            
        } else if indexPath.section == 5 {
            
        } else if indexPath.section == 7 {
            
            let view = AddressPickerView.loadFromNib()
            view.showAsPicker(height: 250)
            view.didSelectCode = { [weak self] in
                guard let `self` = self else {return}
                self.areaId = $0
                let address = LocationManager.shared.address(withCode: $0)
                self.areaTextField.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            }
            
        } else if indexPath.section == 5 {
            
        }

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
