//
//  Reusable+RxSwift.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import RxSwift
import Reusable

//extension Reactive where Base : UITableView {
//    
//    public func items<S, C: UITableViewCell, O>(cellType: C.Type) -> (O) -> (@escaping (Int, S.Iterator.Element, C) -> Swift.Void) -> Disposable where S : Sequence, C : Reusable, O : ObservableType, O.E == S {
//        return items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType.self)
//    }
//}
//
//
//extension Reactive where Base : UICollectionView {
//    
//    public func items<S, C: UICollectionViewCell, O>(cellType: C.Type) -> (O) -> (@escaping (Int, S.Iterator.Element, C) -> Swift.Void) -> Disposable where S : Sequence, C : Reusable, O : ObservableType, O.E == S {
//        return items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType.self)
//    }
//}

