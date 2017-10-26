//
//  BackendHomeViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class BackendHomeViewController: UIViewController, FromMainStoryboard {
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private var partner: Partner? {
        didSet {
            avatarButton.web.setImage(with: partner?.icon, for: .normal)
            nameLabel.text = partner?.name
            let address = LocationManager.shared.address(withCode: partner?.districtCode ?? 0)
            companyLabel.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            countLabel.text = "血缘客户\(partner?.customers ?? 0)人"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarBackgroundImage = UIImage()
        navigationBarShadowImageHidden = true
        
        let api = APIPath(path: "/user/partner")
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: Partner) in
            self?.partner = data
        }).disposed(by: disposeBag)
    }
    
    @IBAction func clickSettingButton(sender: Any) {
        
    }
    
    @IBAction func clickMessageButton(sender: Any) {
        
    }
    
    @IBAction func clickShareButton(sender: Any) {
        
    }
    
    @IBAction func clickBusinessButton(sender: Any) {
        let controller = BusinessManagerViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickStockButton(sender: Any) {
        let controller = MyStockManagerViewController.instantiate()
        controller.partner = partner
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func clickDeliveryButton(sender: Any) {
        let controller = DeliveryManagerViewController.instantiate()
        controller.partner = partner
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func clickBuyButton(sender: Any) {
        let controller = BuyManagerViewController.instantiate()
        controller.partner = partner
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func clickCaculateButton(sender: Any) {
        let controller = CaculateManagerViewController.instantiate()
        controller.partner = partner
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}


