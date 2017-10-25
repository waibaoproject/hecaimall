//
//  FavoriteAndViewedGridView.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/18.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

class FavoriteAndViewedGridView: UIView {
    
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
    
    var messageCount: MessageCount? {
        didSet {
            tabs[0].count = messageCount?.productsFavoritedCount
            tabs[1].count = messageCount?.headlinesFavoritedCount
            tabs[2].count = messageCount?.productsViewedCount
            tabs[3].count = messageCount?.headlinesViewedCount
            gridView.reloadData()
        }
    }
    
    fileprivate lazy var tabs: [GridTab] = { [unowned self] in
        // TODO: 增加点击事件
        
        let tab1 = GridTab(name: "商品收藏", icon: UIImage(asset: .favoritedProducts), handler: { [unowned self] in
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = ProductFavoritedViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        let tab2 = GridTab(name: "资讯收藏", icon: UIImage(asset: .favoritedHeadlines), handler: { [unowned self] in
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = HeadlineFavoritedViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        let tab3 = GridTab(name: "商品足迹", icon: UIImage(asset: .viewedProducts), handler: { [unowned self] in
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = ProductViewedViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        let tab4 = GridTab(name: "资讯足迹", icon: UIImage(asset: .viewedHeadlines), handler: { [unowned self] in
            guard LoginCenter.default.isLogin else {
                LoginCenter.default.forceLogin()
                return
            }
            let controller = HeadlineViewedViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        })
        return [tab1, tab2, tab3, tab4]
    }()
}

extension FavoriteAndViewedGridView: GridViewDataSource {
    
    func numberOfItems(in gridView: GridView) -> Int {
        return tabs.count
    }
    
    func gridView(_ gridView: GridView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(forIndex: index) as GridCell
        cell.tab = tabs[index]
        return cell
    }
}

extension FavoriteAndViewedGridView: GridViewDelegate {
    
    func gridView(_ gridView: GridView, didSelectItemAt index: Int) {
        tabs[index].handler()
    }
}



