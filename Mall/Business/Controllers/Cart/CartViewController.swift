//
//  CartViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import PullRefresh

class CartViewController: UIViewController {
    
    @IBOutlet weak var selectedAllButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var totoalPayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedAllHolderView: UIView!
    
    private var cart: Cart?  {
        didSet {
            if let cart = cart, cart.items.count > 0 {
                selectedAllHolderView.isHidden = false
            }else {
                selectedAllHolderView.isHidden = true
            }
            
        }
    }
    private var products: [Product] = []
    
    private let disposeBag = DisposeBag()
    
    private var productsApi: DefaultNextableArrayDataSource? = DefaultNextableArrayDataSource(api: NextableAPIPath(path: "/product/recommend"))

    
    var isEditMode: Bool {
        return editButton.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "购物车"
        
        automaticallyAdjustsScrollViewInsets = false
        
        selectedAllHolderView.isHidden = true
        
        collectionView.contentInset = .zero

        collectionView.alwaysBounceVertical = true
        
        
        
        collectionView.register(cellType: RecommandProductCell.self)
        collectionView.register(supplementaryViewType: CartSecionHeader.self, ofKind: UICollectionElementKindSectionHeader)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "SectionFooter")
        
        collectionView.addPullRefresh { [weak self] in
            self?.loadCart()
            self?.productsApi = self?.productsApi?.first()
            self?.loadProducts()
        }
//        collectionView.startPullRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgImage = UIImage(named: "bar_bg")
        navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
        navigationController?.navigationBar.tintColor = .white
        if LoginCenter.default.isLogin {
           collectionView.startPullRefresh()
        } else {
            cart = nil
            products = []
            collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func loadCart() {
        let accessory = RefreshAccessory(view: collectionView)
        DefaultDataSource(api: APIPath(path: "/cart/cartList")).response(accessory: accessory)
            .subscribe(onNext: { [weak self] (cart: Cart) in
                self?.cart = cart
                self?.totoalPayLabel.text = cart.totalPayment.display
                self?.collectionView.reloadData()
                self?.selectedAllButton.isSelected = cart.items.reduce(true, { (result, item) in
                    return result && item.isSelected
                })
            })
            .disposed(by: disposeBag)
    }
    
    
    
    private func loadProducts() {
        let accessory = RefreshAccessory(view: collectionView)
        productsApi?.response(accessory: accessory).subscribe(onNext: { [weak self] (products: [Product]) in
            self?.products = products
            self?.collectionView.reloadData()
            self?.productsApi = self?.productsApi?.next()
        })
        .disposed(by: disposeBag)
    }
    
    @IBAction func clickSelectAllButton(sender: UIButton) {
        guard var cart = cart else {return}
        sender.isSelected = !sender.isSelected
        
        cart.items = cart.items.map {
            var item = $0
            item.isSelected = sender.isSelected
            return item
        }
        
        modifyCart(cart: cart)
    }
    
    @IBAction func clickEditButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        collectionView.reloadData()
    }
    
    @IBAction func clickConfirmButton(sender: Any) {
        guard let cart = cart else {return}
        let view = LoadingAccessory(view: self.view)
        let parameters: [String: Any] = {
            var p: [String: Any] = [:]
            for item in cart.items where item.isSelected {
                p["products[\(item.product.id)]"] = item.count
            }
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

extension CartViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if cart == nil {
            return 0
        } else {
            return 1 + (products.count == 0 ? 0 : 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return cart!.items.count
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            var item = cart!.items[indexPath.row]
            if isEditMode {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as CartItemEditCell
                cell.productItem = item
                cell.didClickSelect = { [weak self] _ in
                    guard let `self` = self else {return}
                    var cart = self.cart!
                    item.isSelected = !item.isSelected
                    cart.items[indexPath.row] = item
                    self.modifyCart(cart: cart)
                }
                cell.didClickDelete = { [weak self] _ in
                    guard let `self` = self else {return}
                    let controller = UIAlertController(title: "是否删除此商品", message: nil, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                    })
                    let action2 = UIAlertAction(title: "确定", style: .default, handler: { _ in
                        var cart = self.cart!
                        cart.items[indexPath.row].count = 0
                        self.modifyCart(cart: cart)
                    })
                    controller.addAction(action1)
                    controller.addAction(action2)
                    self.present(controller, animated: true, completion: nil)
                }
                cell.didClickAdd = { [weak self] _ in
                    guard let `self` = self else {return}
                    var cart = self.cart!
                    cart.items[indexPath.row].count += 1
                    self.modifyCart(cart: cart)
                }
                cell.didClickReduce = { [weak self] _ in
                    guard let `self` = self else {return}
                    guard item.count > 1 else {return}
                    var cart = self.cart!
                    cart.items[indexPath.row].count -= 1
                    self.modifyCart(cart: cart)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as CartItemCell
                cell.productItem = item
                cell.didClickSelect = { [weak self] _ in
                    guard let `self` = self else {return}
                    var cart = self.cart!
                    item.isSelected = !item.isSelected
                    cart.items[indexPath.row] = item
                    self.modifyCart(cart: cart)
                }
                return cell
            }
            
        } else {
            
            let product = products[indexPath.row]
            let cell = collectionView.dequeueReusableCell(for: indexPath) as RecommandProductCell
            cell.product = product
            return cell
        }
    }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = collectionView.bounds.width
            return CGSize(width: width, height: 100)
        } else {
            return RecommandProductCell.cellSize(collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reuseIdentifier = kind == UICollectionElementKindSectionHeader ? "CartSecionHeader": "SectionFooter"
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            view.backgroundColor = .clear
            return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: .leastNormalMagnitude)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = (section == 0 ? 2 : 10)
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        } else {
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 2 : 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let controller = ProductViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.product = products[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension CartViewController {
    
    func modifyCart(cart: Cart) {
        
        var parameters: [String: Any] = [:]
        var selectedIds: [String] = []
        for item in cart.items {
            parameters["products[\(item.product.id)]"] = item.count
            if item.isSelected {
                selectedIds.append(item.product.id)
            }
        }
        parameters["selected_products"] = selectedIds.joined(separator: ",")
        
        DefaultDataSource(api: APIPath(method: .put, path: "/cart/editCart", parameters: parameters))
            .response(accessory: LoadingAccessory(view: self.view, message: nil))
            .subscribe(onNext: {[weak self] (cart: Cart) in
                self?.cart = cart
                self?.totoalPayLabel.text = cart.totalPayment.display
                self?.collectionView.reloadData()
                self?.selectedAllButton.isSelected = cart.items.reduce(true, { (result, item) in
                    return result && item.isSelected
                })
            })
        .disposed(by: disposeBag)
    }
}
