//
//  ProductGroupsViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import PullRefresh
import GearNetwork
import RxSwift
import FoundationExtension

class ProductGroupsViewController: UIViewController {
    
    private enum Section {
        case productGroup(ProductGroup, [Item])
        
        var items: [Item] {
            switch self {
            case let .productGroup(_, data):
                return data
            }
        }
    }
    
    private enum Item {
        case product(Product)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(hex: 0x595757)!, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(hex: 0xDC2727)!, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: .selected)
        }
    }
    @IBOutlet weak var groupSelectView: GroupSelectView!

    private var sections: [Section] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var allProductGroups: [ProductGroup] = []
    
    private var isPlat: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "商城"
        tabBarItem.title = "分类"
//        navigationBarBackgroundImage = UIImage(named: "bar_bg")
        collectionView.alwaysBounceVertical = true
        collectionView.register(supplementaryViewType: ProductGroupCollectionHeader.self, ofKind: UICollectionElementKindSectionHeader)
        collectionView.register(supplementaryViewType: ProductGroupCollectionHeader.self, ofKind: UICollectionElementKindSectionFooter)

        collectionView.register(cellType: ProductPlatCollectionViewCell.self)
        collectionView.register(cellType: ProductCollectionViewCell.self)
        
        groupSelectView.didSelect = { [unowned self] _ in
            self.filterAndSortData()
        }
        
        collectionView.addPullRefresh() { [weak self] in
            self?.loadData()
        }
        
        delay(time: 0.2) {
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgImage = UIImage(named: "bar_bg")
        navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
    
    @IBAction func clickPlatButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isPlat = !isPlat
    }
    
    @IBAction func segmentedControlValueChanged(sender: Any) {
        filterAndSortData()
    }
    
    private func loadData() {
        
        DefaultArrayDataSource(api: APIPath(path: "/product/product_groups")).response(accessory: RefreshAccessory(view: collectionView))
            .subscribe(onNext: { (data: [ProductGroup]) in
                self.allProductGroups = data
                
                self.groupSelectView.items = {
                    var types: [String] = []
                    for group in data {
                        if let type = group.type, !types.contains(type) {
                            types.append(type)
                        }
                    }
                    return types
                }()

                self.filterAndSortData()
                self.collectionView.stopPullRefresh()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func filterAndSortData() {
        
        let selectedType = groupSelectView.items[groupSelectView.selectedIndex]
        
        let selectedProductGroups = allProductGroups.filter {
            if let type = $0.type, type == selectedType {
                return true
            }
            return false
        }
        
        sections = selectedProductGroups.map { group in
            
            let items: [Item] = {
                if segmentedControl.selectedSegmentIndex == 0 {
                    return group.products.sorted(by: { (product1, product2) in
                        product1.recommandScore > product2.recommandScore
                    }).map { Item.product($0) }
                } else if segmentedControl.selectedSegmentIndex == 1 {
                    return group.products.sorted(by: { (product1, product2) in
                        product1.salesCount > product2.salesCount
                    }).map { Item.product($0) }
                }else {
                    return group.products.sorted(by: { (product1, product2) in
                        product1.price.cent > product2.price.cent
                    }).map { Item.product($0) }
                }
            }()
            
            return Section.productGroup(group, items)
        }
    }
}

extension ProductGroupsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].items[indexPath.row] {
        case let .product(data):
            if isPlat {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductPlatCollectionViewCell
                cell.product = data
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath) as ProductCollectionViewCell
                cell.product = data
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as ProductGroupCollectionHeader
            var productGroup: ProductGroup {
                switch sections[indexPath.section] {
                case let .productGroup(group, _):
                    return group
                }
            }
            view.coverImageView.web.setImage(with: productGroup.cover)
            return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = width / 2.5
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = CGFloat.leastNormalMagnitude
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension ProductGroupsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPlat {
            return ProductPlatCollectionViewCell.cellSize(collectionView: collectionView)
        } else {
            return ProductCollectionViewCell.cellSize(collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch sections[indexPath.section].items[indexPath.row] {
        case let .product(data):
            let controller = ProductViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.product = data
            navigationController?.pushViewController(controller, animated: true)
            
        }
        
    }
}
