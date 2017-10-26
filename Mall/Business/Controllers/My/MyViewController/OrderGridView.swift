//
//  OrderGridView.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class OrderGridView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var gridView: GridView = { [unowned self] in
        let view = GridView()
        view.itemSize = CGSize(width: 90, height: 70)
        view.lineSpacing = 20
        view.dataSource = self
        view.delegate = self
        view.register(cellType: GridCell.self)
        return view
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(gridView)
        gridView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        gridView.reloadData()
    }
    
    fileprivate lazy var tabs: [GridTab] = { [unowned self] in
        
        let tab1 = GridTab(name: "待支付", icon: UIImage(asset: .waitForPay), handler: { [unowned self] in
            LoginCenter.default.loginIfNeeded().subscribe(onNext: { [unowned self] (_) in
                let controller = OrdersIndexViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.initialIndex = 1
                self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: self.disposeBag)
        })
        let tab2 = GridTab(name: "待发货", icon: UIImage(asset: .waitForDeliver), handler: { [unowned self] in
            LoginCenter.default.loginIfNeeded().subscribe(onNext: { [unowned self] (_) in
                let controller = OrdersIndexViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.initialIndex = 2
                self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: self.disposeBag)
        })
        let tab3 = GridTab(name: "待收货", icon: UIImage(asset: .waitForReceive), handler: { [unowned self] in
            LoginCenter.default.loginIfNeeded().subscribe(onNext: { [unowned self] (_) in
                let controller = OrdersIndexViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.initialIndex = 3
                self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: self.disposeBag)
        })
        let tab4 = GridTab(name: "待评价", icon: UIImage(asset: .waitForComment), handler: { [unowned self] in
            LoginCenter.default.loginIfNeeded().subscribe(onNext: { [unowned self] (_) in
                let controller = OrdersIndexViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.initialIndex = 4
                self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: self.disposeBag)
        })
        return [tab1, tab2, tab3, tab4]
        }()
}

extension OrderGridView: GridViewDataSource {
    
    func numberOfItems(in gridView: GridView) -> Int {
        return tabs.count
    }
    
    func gridView(_ gridView: GridView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(forIndex: index) as GridCell
        cell.tab = tabs[index]
        return cell
    }
}

extension OrderGridView: GridViewDelegate {
    
    func gridView(_ gridView: GridView, didSelectItemAt index: Int) {
        tabs[index].handler()
    }
}



