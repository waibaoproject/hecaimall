//
//  GridView.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/18.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

protocol GridViewDataSource: class {
    func numberOfItems(`in` gridView: GridView) -> Int
    func gridView(_ gridView: GridView, cellForItemAt index: Int) -> UICollectionViewCell
}

protocol GridViewDelegate: class {
    func gridView(_ gridView: GridView, didSelectItemAt index: Int)
}

class GridView: UIView {
    
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = .leastNormalMagnitude
        layout.minimumInteritemSpacing = .leastNormalMagnitude
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        self.addSubview(view)
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        view.dataSource = self
        view.delegate = self
        
        return view
        }()
    
    weak var dataSource: GridViewDataSource?
    weak var delegate: GridViewDelegate?
    
    var itemSize: CGSize = CGSize(width: 30, height: 30)
    var numberOfItemsOneline: Int = 4
    var lineSpacing: CGFloat = 10.0
    
    final public func register<T>(cellType: T.Type) where T : UICollectionViewCell, T : NibLoadable, T : Reusable {
        collectionView.register(cellType: cellType)
    }
    
    final public func register<T>(cellType: T.Type) where T : UICollectionViewCell, T : Reusable {
        collectionView.register(cellType: cellType)
    }

    final public func dequeueReusableCell<T>(forIndex index: Int) -> T where T : UICollectionViewCell, T : Reusable {
        return collectionView.dequeueReusableCell(for: IndexPath(item: index, section: 0))
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension GridView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return (collectionView.bounds.width - itemSize.width * CGFloat(numberOfItemsOneline)) / (CGFloat(numberOfItemsOneline) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.gridView(self, didSelectItemAt: indexPath.row)
    }
}

extension GridView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource?.gridView(self, cellForItemAt: indexPath.row) ?? UICollectionViewCell()
    }
}
