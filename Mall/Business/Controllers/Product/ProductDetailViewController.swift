//
//  ProductDetailViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/27.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class ProductDetailViewController: UIViewController, FromProductStoryboard {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var product: Product?
    
    private let disposeBag = DisposeBag()
    
    var didPushRefresh: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.register(cellType: BannersCell.self)
        
        let productId = product?.id ?? "1Q4lvkrZV5"
        DefaultDataSource(api: APIPath(path: "/product/view/id/\(productId)")).response(accessory: LoadingAccessory(view: view))
            .subscribe(onNext: { [weak self] (data: Product) in
                guard let `self` = self else {return}
                self.product = data
                self.favoriteButton.isSelected = data.isFavorited
                self.tableView.reloadData()
            })
        .disposed(by: disposeBag)
        
        tableView.addPushRefresh { [weak self] in
            self?.didPushRefresh?()
            self?.tableView.stopPushRefresh()
        }
    }
    
    @IBAction func clickCustomServiceButton(sender: Any) {
        let controller = CustomServiceViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func clickFavoriteButton(sender: UIButton) {
        guard let product = product else {return}
        let productId = product.id
        if product.isFavorited {
            LoginCenter.default.loginIfNeeded().flatMap({ _ in
                responseVoid(accessory: LoadingAccessory(view: self.view), urlRequest: APIPath(method: .delete, path: "/user/favProduct/id/\(productId)"))
            })
                .subscribe(onNext: {
                    self.product?.isFavorited = false
                    sender.isSelected = false
                    self.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        } else {
            LoginCenter.default.loginIfNeeded().flatMap({ _ in
                responseVoid(accessory: LoadingAccessory(view: self.view), urlRequest: APIPath(method: .post, path: "/user/favProduct/id/\(productId)"))
            })
                .subscribe(onNext: {
                    self.product?.isFavorited = true
                    sender.isSelected = true
                    self.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        }
    }
    
    @IBAction func clickCartButton(sender: Any) {
        guard let productId = product?.id else {return}
        LoginCenter.default.loginIfNeeded().flatMap({ _ in
            responseVoid(accessory: LoadingAccessory(view: self.view), urlRequest: APIPath(method: .post, path: "/cart/addToCart/id/\(productId)"))
        })
            
            .subscribe(onNext: { [weak self] in
            self?.noticeOnlyText("加入购物车成功")
        })
        .disposed(by: disposeBag)
    }
    
    @IBAction func clickBuyButton(sender: Any) {
        guard let product = product else {return}
        let view = LoadingAccessory(view: self.view)
        let parameters: [String: Any] = {
            var p: [String: Any] = [:]
            p["products[\(product.id)]"] = 1
            return p
        }()
        let api = APIPath(method: .post, path: "/user/orders", parameters: parameters)
        DefaultDataSource(api: api).response(accessory: view).subscribe(onNext: { [weak self] (order: Order) in
            guard let `self` = self else {return}
            let controller = OrderViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.order = order
            self.navigationController?.pushViewController(controller, animated: true)
        })
            .disposed(by: disposeBag)
    }
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as BannersCell
            cell.linkable = false
            cell.banners = product?.images.map({ Banner(image: $0, link: nil) }) ?? []
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProductBriefCell
            cell.product = product
            return cell
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "ProductParameterCell", for: indexPath)
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "ProductCategoryCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.bounds.width
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF4F4F4)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
