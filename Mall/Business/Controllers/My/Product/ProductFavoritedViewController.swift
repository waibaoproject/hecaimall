//
//  ProductFavoritedViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/5.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import FoundationExtension
import RxSwift

class ProductFavoritedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FromProductStoryboard {
    
    private var selectedProductIds: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBar: UIView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    private var isEditMode: Bool = false
    
    private var api = NextableAPIPath(path: "/user/favProductList")
    private var products: [Product] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "商品收藏"
        
        tableView.register(cellType: ProductViewedCell.self)
        
        reloadData()
        
        tableView.addPullRefresh { [weak self] in
            guard let `self` = self else {return}
            self.api = self.api.first()
            self.load()
        }
        
        tableView.addPushRefresh { [weak self] in
            guard let `self` = self else {return}
            self.load()
        }
        
        delay(time: 0.5) {
            self.tableView.startPullRefresh()
        }
    }
    
    func reloadData() {
        deleteBar.isHidden = !isEditMode
        selectedLabel.text = "已选择\(selectedProductIds.count)个商品"
        tableView.contentInset = UIEdgeInsetsMake(0, 0, isEditMode ? 40: 0, 0)
        tableView.reloadData()
    }
    
    @IBAction func clickEditButton(sender: UIButton) {
        isEditMode = !isEditMode
        sender.isSelected = isEditMode
        reloadData()
    }
    
    @IBAction func clickDelete(sender: UIButton) {
        guard selectedProductIds.count > 0 else {return}
        let loading = LoadingAccessory(view: view)
        let ids = selectedProductIds.joined(separator: ",")
        responseVoid(accessory: loading, urlRequest: APIPath(method: .delete, path: "/user/favProduct/id/\(ids)"))
            .subscribe(onNext: {[weak self]  () in
                guard let `self` = self else {return}
                
                self.products = self.products.filter({
                    !self.selectedProductIds.contains($0.id)
                })
                self.selectedProductIds.removeAll()
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func load() {
        
        let accessory = RefreshAccessory(view: tableView)
        DefaultNextableArrayDataSource(api: api).response(accessory: accessory)
            .subscribe(onNext: {[weak self] (data: [Product]) in
                guard let `self` = self else {return}
                
                if self.api.isFirst {
                    self.products = data
                } else {
                    self.products += data
                }
                self.reloadData()
                self.api = self.api.next()
                
            }).disposed(by: disposeBag)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProductViewedCell
        let product = products[indexPath.row]
        cell.product = product
        cell.isEditMode = isEditMode
        cell.is_selected = selectedProductIds.contains(product.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if isEditMode {
            let isSelected = selectedProductIds.contains(product.id)
            if isSelected {
                selectedProductIds.remove(product.id)
            } else {
                selectedProductIds.append(product.id)
            }
            reloadData()
            
        } else {
            let controller = ProductViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.product = product
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

