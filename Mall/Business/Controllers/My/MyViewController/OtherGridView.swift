//
//  OtherGridView.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SnapKit

class OtherGridView: UIView {
    
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
        let tab1 = GridTab(name: "专家咨询", icon: UIImage(asset: .expert), handler: { [unowned self] in
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = ExpertViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        let tab2 = GridTab(name: "客服热线", icon: UIImage(asset: .hotline), handler: { [unowned self] in
   
            let controller = CustomServiceViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        let tab3 = GridTab(name: "关于我们", icon: UIImage(asset: .aboutUs), handler: { [unowned self] in
            let controller = WebViewController()
            controller.hidesBottomBarWhenPushed = true
            controller.title = "关于我们"
            controller.urlString = "http://gc.ucardpro.com/v1/detail/about"
             self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        let tab4 = GridTab(name: "", icon: UIImage(), handler: { [unowned self] in
            
        })
        return [tab1, tab2, tab3, tab4]
        }()
}

extension OtherGridView: GridViewDataSource {
    
    func numberOfItems(in gridView: GridView) -> Int {
        return tabs.count
    }
    
    func gridView(_ gridView: GridView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(forIndex: index) as GridCell
        cell.tab = tabs[index]
        return cell
    }
}

extension OtherGridView: GridViewDelegate {
    
    func gridView(_ gridView: GridView, didSelectItemAt index: Int) {
        tabs[index].handler()
    }
}
