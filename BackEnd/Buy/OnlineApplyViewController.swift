//
//  OnlineApplyViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift
import FoundationExtension

class OnlineApplyViewController: UITableViewController, FromBuyStoryboard {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    @IBOutlet weak var receiverNameLabel: UITextField!
    @IBOutlet weak var receiverPhoneTextField: UITextField!
    @IBOutlet weak var receiverDistrictTextField: UITextField!
    @IBOutlet weak var receiverDetailTextView: PlaceholderTextView!

    private var products: [Product] = []
    
    private var selectedProduct: Product? {
        didSet {
            productNameLabel.text = selectedProduct?.name
            priceLabel.text = selectedProduct?.price.display
            totalPaymentLabel.text = totalPayment.display
        }
    }
    
    var partner: Partner? {
        didSet {
            reloadData()
        }
    }
    
    private var districtId: UInt = 0
    
    private var totalPayment: Price {
        let count = countTextField.text?.uintValue ?? 0
        if let price = selectedProduct?.price {
            return (price * count)
        } else {
            return Price.cent(0)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        DefaultArrayDataSource(api: APIPath(path: "/procurement/order/products")).response(accessory: nil).subscribe(onNext: { [weak self] (data: [Product]) in
            guard let `self` = self else {return}
            self.products = data
        }).disposed(by: disposeBag)
        
        if let partner = partner, partner.merchantType == .base {
            districtId = partner.districtCode
            receiverNameLabel.text = partner.receiver?.name
            receiverPhoneTextField.text = partner.receiver?.phone
            let address = LocationManager.shared.address(withCode: districtId)
            receiverDistrictTextField.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            receiverDetailTextView.text = partner.address
        }
        reloadData()
    }
    
    private func reloadData() {
        if let partner = partner, partner.merchantType == .base, isViewLoaded == true {
            districtId = partner.receiver?.districtCode ?? 0
            receiverNameLabel.text = partner.receiver?.name
            receiverPhoneTextField.text = partner.receiver?.phone
            let address = LocationManager.shared.address(withCode: districtId)
            receiverDistrictTextField.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            receiverDetailTextView.text = partner.receiver?.detail
        }
        tableView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }

    
    @IBAction func valueChanged(sender: Any) {
        totalPaymentLabel.text = totalPayment.display
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let partner = partner, partner.merchantType == .base {
            return 5
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if indexPath.section == 0 {
            let view = ItemsSelectionView()
            view.items = products.flatMap({ $0.name })
            view.selected = { [weak self] (value, index) in
                guard let `self` = self else {return}
                self.selectedProduct = self.products[index]
            }
            view.showAsPicker(height: 250)
        } else if indexPath.section == 4 && indexPath.row == 2 {
            let view = AddressPickerView.loadFromNib()
            view.showAsPicker(height: 250)
            view.didSelectCode = { [weak self] in
                guard let `self` = self else {return}
                self.districtId = $0
                let address = LocationManager.shared.address(withCode: $0)
                self.receiverDistrictTextField.text = [address.province?.name, address.city?.name, address.district?.name].flatMap({ $0 }).joined(separator: " ")
            }
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
    
    @IBAction func clickBuyButton(sender: Any) {
        view.endEditing(true)

        guard let product = selectedProduct else {
            view.toast("请选择商品")
            return
        }
        
        guard let count = countTextField.text?.uintValue, count > 0 else {
            view.toast("请输入购买数量")
            return
        }
        
        let id = product.id
        
        var parameters: [String: Any] = ["id": id,
                                         "count": count]
        
        if let partner = partner, partner.merchantType == .base {
            guard let name = receiverNameLabel.text, !name.isBlankString else {
                view.toast("请填写收货人姓名")
                return
            }
            
            guard let phone = receiverPhoneTextField.text, !phone.isBlankString else {
                view.toast("请填写联系电话")
                return
            }
            
            guard districtId != 0 else {
                view.toast("请选择所在地区")
                return
            }
            
            guard let detail = receiverDetailTextView.text, !detail.isBlankString else {
                view.toast("请填写详细地址")
                return
            }
            
            parameters["name"] = name
            parameters["phone"] = phone
            parameters["district_code"] = districtId
            parameters["detail"] = detail
        }
        
        
        func loadOrder(success: @escaping (ProcurementOrder) -> Void) {
            let api = APIPath(method: .post, path: "/online/procurement/orders", parameters: parameters)
            let loading = LoadingAccessory(view: view)
            DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { (data: ProcurementOrder) in
                success(data)
            }).disposed(by: disposeBag)
        }
        
        loadOrder {[weak self] (order) in
            guard let `self` = self else {return}
            let time = Int(Date().timeIntervalSince1970)
            let key = "t5e31fd03vcq76"
            let md5 = MD5("\(order.id)").lowercased()
            let secret = MD5("\(md5)\(time)\(key)").lowercased()
            let parameters0: [String: Any] = [
                "id": order.id,
                "time": time,
                "secret": secret
            ]
            let api0 = APIPath(method: .post, path: "/balancepay", parameters: parameters0)
            let loading0 = LoadingAccessory(view: self.view)
            DefaultDataSource(api: api0).response(accessory: loading0).catchErrorWithComplete(handler: {[weak self] (error) in
                guard let `self` = self else {return}
                if error.code == 40109 {
                    payForProcurementOrder(id: order.id, in: self, disposeBag: self.disposeBag)
                } else {
                    self.view.toast(error.localizedDescription)
                }
            }).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
                guard let `self` = self else {return}
                self.view.toast("余额扣款成功")
                delay(time: 0.8, task: {
                    jumpToProcurementOrderList(in: self)
                })
                
            }).disposed(by: self.disposeBag)
        }
    }
}

func payForProcurementOrder(id: String, `in` controller: UIViewController, disposeBag: DisposeBag) {
    
    let time = Int(Date().timeIntervalSince1970)
    let key = "t5e31fd03vcq76"
    let md5 = MD5("\(id)").lowercased()
    let secret = MD5("\(md5)\(time)\(key)").lowercased()
    let parameters0: [String: Any] = [
        "id": id,
        "time": time,
        "secret": secret
    ]
    let api0 = APIPath(method: .post, path: "/balancepay", parameters: parameters0)
    let loading0 = LoadingAccessory(view: controller.view)
    DefaultDataSource(api: api0).response(accessory: loading0).catchErrorWithComplete(handler: { (error) in
        
        if error.code == 40109 {
            payForThirdParty(id: id, in: controller, disposeBag: disposeBag)
        } else {
            controller.view.toast(error.localizedDescription)
        }
    }).subscribe(onNext: { (data: ProcurementOrder) in
        
        controller.view.toast("余额扣款成功")
        delay(time: 0.8, task: {
            jumpToProcurementOrderList(in: controller)
        })
        
    }).disposed(by: disposeBag)

}

private func payForThirdParty(id: String, `in` controller: UIViewController, disposeBag: DisposeBag) {
 
    askForPayWay(aliPay: {
        aliPayForProcurementOrder(id: id, in: controller, disposeBag: disposeBag)
    }, wechatPay: {
        wechatPayForProcurementOrder(id: id, in: controller, disposeBag: disposeBag)
    }, cancel: {
        jumpToProcurementOrderList(in: controller)
    })
}

private func aliPayForProcurementOrder(id: String, `in` controller: UIViewController, disposeBag: DisposeBag) {
    let loading = LoadingAccessory(view: controller.view)
    DefaultDataSource(api: APIPath(path: "/procurement/orders/\(id)/payment/alipay")).response(accessory: loading).subscribe(onNext: { (info: AliPayInfo) in
        apiPay(info: info, success: {
            jumpToProcurementOrderList(in: controller)
        }, failure: { reson in
            controller.view.toast(reson)
            jumpToProcurementOrderList(in: controller)
        })
    }).disposed(by: disposeBag)
}

private func wechatPayForProcurementOrder(id: String, `in` c: UIViewController, disposeBag: DisposeBag) {
    // TODO
    DefaultDataSource(api: APIPath(path: "/procurement/orders/\(id)/payment/wechat")).response(accessory: nil).subscribe(onNext: { (info: WechatPayInfo) in
        wechatPay(info: info, success: {
            jumpToProcurementOrderList(in: c)
        }, failure: { reson in
            c.view.toast(reson)
            jumpToProcurementOrderList(in: c)
        })
    }).disposed(by: disposeBag)
}


func jumpToProcurementOrderList(`in` c: UIViewController, isOffline: Bool = false) {
    
    if let controller = UIViewController.topMost as? ProcurementOrderManagerViewController {
        controller.currentController.tableView.startPullRefresh()
    } else {
        let controller = ProcurementOrderManagerViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        c.navigationController?.pushViewController(controller, animated: true)
        controller.isOffline = isOffline
        var controllers = c.navigationController!.viewControllers
        controllers.remove(at: controllers.count - 2)
        c.navigationController?.viewControllers = controllers
    }
}
