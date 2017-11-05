//
//  OnlineApplyViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class OnlineApplyViewController: UITableViewController, FromBuyStoryboard {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    

    private var products: [Product] = []
    private var selectedProduct: Product? {
        didSet {
            productNameLabel.text = selectedProduct?.name
            priceLabel.text = selectedProduct?.price.display
            totalPaymentLabel.text = totalPayment.display
        }
    }
    
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
    }
    
    @IBAction func valueChanged(sender: Any) {
        totalPaymentLabel.text = totalPayment.display
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
    
    @IBAction func clickBuyButton(sender: Any) {
        guard let product = selectedProduct else {
            self.noticeOnlyText("请选择商品")
            return
        }
        
        guard let count = countTextField.text?.uintValue, count > 0 else {
            self.noticeOnlyText("请输入购买数量")
            return
        }
        
        let id = product.id
        
        let api = APIPath(method: .post, path: "/online/procurement/orders", parameters: ["id": id, "count": count])
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: ProcurementOrder) in
            guard let `self` = self else {return}
            askForPayWay(aliPay: {
                self.aliPay(for: data)
            }, wechatPay: {
                //TODO
            })
        }).disposed(by: disposeBag)
    }
    
    private func aliPay(for order: ProcurementOrder) {
        DefaultDataSource(api: APIPath(path: "/procurement/orders/\(order.id)/payment/alipay")).response(accessory: nil).subscribe(onNext: { (info: AliPayInfo) in
            apiPay(info: info, success: {
                
            }, failure: {
                
            })
        }).disposed(by: disposeBag)
    }
}
