//
//  OrdersViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/3.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class OrdersViewController: UICollectionViewController {
    
    enum Section {
        case order([Cell])
        case products([Cell])
        
        var cells: [Cell] {
            switch self {
            case let .order(data):
                return data
            case let .products(data):
                return data
            }
        }
    }
    
    enum Cell {
        case orderHeader(Order)
        case orderFooter(Order)
        case productItem(ProductItem)
        case product(Product)
        case noOrder
    }
    
    private var orders: [Order] = []
    private var products: [Product] = []
    
    private var sections: [Section] = []
    
    var orderState: OrderState?
    
    private var ordersApi: NextableAPIPath!
    private var productsApi = NextableAPIPath(path: "/product/recommend")
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(hex: 0xEEEEEE)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(cellType: OrderItemCell.self)
        collectionView?.register(cellType: RecommandProductCell.self)
        collectionView?.register(cellType: OrderHeaderView.self)
        collectionView?.register(cellType: OrderFooterView.self)
        collectionView?.register(cellType: NoOrderCell.self)

//        collectionView?.register(supplementaryViewType: CartSecionHeader.self, ofKind: UICollectionElementKindSectionHeader)
//        collectionView?.register(supplementaryViewType: OrderFooterView.self, ofKind: UICollectionElementKindSectionFooter)

        let parameters: [String: Any] = {
            if let state = orderState {
                return ["state": state.rawValue]
            } else {
                return [:]
            }
        }()
        ordersApi = NextableAPIPath(path: "/user/orders", parameters: parameters)

        collectionView?.addPullRefresh { [weak self] in
            guard let `self` = self else {return}
            self.ordersApi = self.ordersApi.first()
            self.productsApi = self.productsApi.first()
            self.loadOrders()
            self.loadProducts()
        }
        
        collectionView?.addPushRefresh { [weak self] in
            guard let `self` = self else {return}
            self.loadOrders()
            self.loadProducts()
        }
        
        delay(time: 0.5) {
            self.collectionView?.startPullRefresh()
        }
    }

    func loadOrders() {
        DefaultNextableArrayDataSource(api: ordersApi).response(accessory: RefreshAccessory(view: collectionView!))
            .subscribe(onNext: {[weak self] (orders: [Order]) in
                guard let `self` = self else {return}
                if self.ordersApi.isFirst {
                    self.orders = orders
                } else {
                    self.orders += orders
                    
                }
                self.generateSections()
                self.collectionView?.reloadData()
                self.ordersApi = self.ordersApi.next()
            })
            .disposed(by: disposeBag)
    }
    
    func loadProducts() {
        DefaultNextableArrayDataSource(api: productsApi).response(accessory: nil)
            .subscribe(onNext: {[weak self] (products: [Product]) in
                guard let `self` = self else {return}
                if self.productsApi.isFirst {
                    self.products = products
                } else {
                    self.products += products
                }
                self.generateSections()
                self.collectionView?.reloadData()
                self.productsApi = self.productsApi.next()
            })
            .disposed(by: disposeBag)
    }
    
    func generateSections() {
        var sections: [Section] = []
        if orders.count <= 0 {
            sections.append(.order([.noOrder]))
            sections.append(.products(products.map({ Cell.product($0) })))
        } else {
            orders.forEach({
                var cells: [Cell] = []
                cells.append(Cell.orderHeader($0))
                cells.append(contentsOf: $0.items.map({ Cell.productItem($0) }))
                cells.append(Cell.orderFooter($0))
                sections.append(Section.order(cells))
            })
        }
        self.sections = sections
        self.collectionView?.reloadData()
    }
}

extension OrdersViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case let .order(data):
            return data.count
        case let .products(data):
            return data.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].cells[indexPath.row] {
        case let .productItem(item):
            let order = self.orders[indexPath.section]
            let cell = collectionView.dequeueReusableCell(for: indexPath) as OrderItemCell
            cell.productItem = item
//            if order.state == .end && !item.isCommented {
//                cell.commentButton.isHidden = false
//            } else {
//                cell.commentButton.isHidden = true
//            }
            cell.didClickComment = { [weak self] in
                guard let `self` = self else {return}
                let controller = ProductCommentViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.orderId = order.id
                controller.product = $0.product
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            return cell
        case let .product(product):
            let cell = collectionView.dequeueReusableCell(for: indexPath) as RecommandProductCell
            cell.product = product
            return cell
        case .noOrder:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NoOrderCell
            return cell
        case let .orderHeader(order):
            let view = collectionView.dequeueReusableCell(for: indexPath) as OrderHeaderView
            view.order = order
            return view
        case let .orderFooter(order):
            let view = collectionView.dequeueReusableCell(for: indexPath) as OrderFooterView
            view.order = order
            view.didClickCancelOrder = { [weak self] in
                self?.cancelOrder(id: $0.id)
            }
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section].cells[indexPath.row] {
        case .productItem:
            return CGSize(width: collectionView.bounds.width, height: 88)
        case .product:
            return RecommandProductCell.cellSize(collectionView: collectionView)
        case .noOrder:
            return CGSize(width: collectionView.bounds.width, height: 300)
        case .orderHeader:
            return CGSize(width: collectionView.bounds.width, height: 40)
        case .orderFooter:
            return CGSize(width: collectionView.bounds.width, height: 77)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch sections[section] {
        case .order:
            return CGFloat.leastNonzeroMagnitude
        case .products:
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch sections[section] {
        case .order:
            return CGFloat.leastNonzeroMagnitude
        case .products:
            return 15
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sections[section] {
        case .order:
            return .zero
        case .products:
            return UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        }
    }
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as CartSecionHeader
//        } else {
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as OrderFooterView
//            view.backgroundColor = .clear
//            return view
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        switch sections[section] {
//        case .order:
//            return CGSize(width: collectionView.bounds.width, height: .leastNonzeroMagnitude)
//        case .products:
//            return CGSize(width: collectionView.bounds.width, height: 40)
//        }
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch sections[section] {
        case .order:
            return CGSize(width: collectionView.bounds.width, height: 5)
        case .products:
            return CGSize(width: collectionView.bounds.width, height: .leastNonzeroMagnitude)
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch sections[indexPath.section].cells[indexPath.row] {
//        case let .product(data):
//            let controller = ProductViewController.instantiate()
//            controller.hidesBottomBarWhenPushed = true
//            controller.product = data
//            navigationController?.pushViewController(controller, animated: true)
//        default:
//            break
//        }
//    }
    
    private func cancelOrder(id: String) {
        let api = APIPath(method: .put, path: "/user/orders/id/\(id)", parameters: ["state": -1])
        DefaultDataSource(api: api)
            .response(accessory: LoadingAccessory(view: view))
            .subscribe(onNext: {[weak self] (orders: Order) in
                guard let `self` = self else {return}
                self.collectionView?.startPullRefresh()
            })
            .disposed(by: disposeBag)
    }
}



import Reusable

class OrderFooter: UICollectionReusableView, Reusable {
    
}
