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
//            let address = LocationManager.shared.address(withCode: partner?.districtCode ?? 0)
//            companyLabel.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            companyLabel.text = partner?.type
            countLabel.text = "血缘客户\(partner?.customers ?? 0)人"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
        let api = APIPath(path: "/user/partner")
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: Partner) in
            self?.partner = data
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .darkGray
    }
    

    @IBAction func clickMessageButton(sender: Any) {
        
    }
    
    @IBAction func clickShareButton(sender: Any) {
        let controller = PartnerViewController.instantiate()
        controller.partner = partner
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
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


