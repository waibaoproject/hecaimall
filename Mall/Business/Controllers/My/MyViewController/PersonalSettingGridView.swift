//
//  PersonalSettingGridView.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class PersonalSettingGridView: UIView {
    
    private lazy var gridView: GridView = { [unowned self] in
        let view = GridView()
        view.itemSize = CGSize(width: 90, height: 70)
        view.lineSpacing = 20
        view.dataSource = self
        view.delegate = self
        view.register(cellType: GridCell.self)
        return view
        }()
    
    private let disposeBag = DisposeBag()
    
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
        // TODO: 增加点击事件
        let tab1 = GridTab(name: "基本信息", icon: UIImage(asset: .profile), handler: { [unowned self] in
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = ProfileViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        
        
        let tab2 = GridTab(name: "健康信息", icon: UIImage(asset: .health), handler: { [unowned self] in
            
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = HealthViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)

        })
        
        let tab3 = GridTab(name: "地址管理", icon: UIImage(asset: .addressManager), handler: { [unowned self] in
            LoginCenter.default.loginIfNeeded().subscribe(onNext: { [unowned self] (_) in
                let controller = AddressManagerViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: self.disposeBag)
        })
        let tab4 = GridTab(name: "", icon: UIImage(), handler: { [unowned self] in
            
        })
        return [tab1, tab2, tab3, tab4]
        }()
}

extension PersonalSettingGridView: GridViewDataSource {
    
    func numberOfItems(in gridView: GridView) -> Int {
        return tabs.count
    }
    
    func gridView(_ gridView: GridView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(forIndex: index) as GridCell
        cell.tab = tabs[index]
        return cell
    }
}

extension PersonalSettingGridView: GridViewDelegate {
    
    func gridView(_ gridView: GridView, didSelectItemAt index: Int) {
        tabs[index].handler()
    }
}

