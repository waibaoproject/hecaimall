//
//  InfiniteScrollingView.swift
//  Pods
//
//  Created by 王小涛 on 16/5/25.
//
//

import UIKit

@objc public protocol InfiniteScrollingViewDataSource {
    func numberOfItems(in infiniteScrollingView: InfiniteScrollingView) -> Int
    func infiniteScrollingView(_ infiniteScrollingView: InfiniteScrollingView, cellForItemAt index: Int) -> UICollectionViewCell
}

@objc public protocol InfiniteScrollingViewDelegate {
    
    @objc optional func infiniteScrollingView(_ infiniteScrollingView: InfiniteScrollingView, didSelectItemAt index: Int)
    
    @objc optional func itemLength(in infiniteScrollingView: InfiniteScrollingView) -> CGFloat
    @objc optional func itemSpacing(in infiniteScrollingView: InfiniteScrollingView) -> CGFloat
    @objc optional func padding(in infiniteScrollingView: InfiniteScrollingView) -> CGFloat
}

public class InfiniteScrollingView: UICollectionView {
    
    @IBOutlet public weak var aDataSource: InfiniteScrollingViewDataSource?
    @IBOutlet public weak var aDelegate: InfiniteScrollingViewDelegate?
    
    public var isInfiniteScrollingEnabled: Bool = true
    
    public var didScrollAt: ((_ index: Int) -> Void)?
    
    fileprivate var rows: Int = 0
    fileprivate var itemLength: CGFloat = 0.0
    fileprivate var itemSpacing: CGFloat = 0.0
    fileprivate var padding: CGFloat = 0.0
    
    fileprivate var unitLength: CGFloat = 0.0
    
    fileprivate var layout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }

    deinit {
        print("\(self) deinit")
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentInset = .zero
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        resetContentOffsetIfNeeded()
    }
}

public extension InfiniteScrollingView {
    
    func dequeueReusableCell(withReuseIdentifier: String, for index: Int) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: IndexPath(row: index, section: 0))
    }
    
    func scrollToNext(animated: Bool = true) {
        
        guard rows >= 2 else { return }
        
        var nextIndex: Int {
            if isInfiniteScrollingEnabled {
                return currentIndex + 1
            }else {
                return (currentIndex + 1) % rows
            }
        }
        
        let y = CGFloat(nextIndex) * unitLength + itemSpacing + itemLength / 2 - boundLength / 2
        setOffset(offset: y, animated: animated)
    }
    
    func scrollToNextPage(animated: Bool = true) {
        
        var nextIndex: Int {
            if isInfiniteScrollingEnabled {
                return currentPageIndex + 1
            }else {
                return (currentPageIndex + 1) % totalPages
            }
        }
        
        let y = CGFloat(nextIndex) * boundLength
        
        setOffset(offset: y, animated: animated)
    }
}

extension InfiniteScrollingView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if rows == 1 {
            return 1
        }else {
            return multiple * rows
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row % rows
        return aDataSource!.infiniteScrollingView(self, cellForItemAt: index)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        initVars()
        return 1
    }
}

extension InfiniteScrollingView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row % rows
        aDelegate?.infiniteScrollingView?(self, didSelectItemAt: index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}

extension InfiniteScrollingView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resetContentOffsetIfNeeded()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     
        guard let didScrollAt = didScrollAt else {return}
        didScrollAt(currentIndex % rows)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
        guard let didScrollAt = didScrollAt else {return}
        didScrollAt(currentIndex % rows)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            guard let didScrollAt = didScrollAt else {return}
            didScrollAt(currentIndex % rows)
        }
    }
}

private extension InfiniteScrollingView {

    var currentIndex: Int {
        return Int((offset + boundLength / 2 - itemLength / 2 - itemSpacing) / unitLength)
    }
    
    var currentPageIndex: Int {
        return Int(offset / boundLength)
    }
    
    var totalPages: Int {
        return Int(ceil(scrollLength / boundLength))
    }
}

private extension InfiniteScrollingView {
    
    func setup() {
        dataSource = self
        delegate = self
    }
    
    func initVars() {
        
        if let rows = aDataSource?.numberOfItems(in: self) {
            self.rows = rows
        }
        
        if let itemLength = aDelegate?.itemLength?(in: self) {
            self.itemLength = itemLength
        }else {
            self.itemLength = layout.scrollDirection == .horizontal ? bounds.width : bounds.height
        }
        
        if let itemSpacing = aDelegate?.itemSpacing?(in: self) {
            self.itemSpacing = itemSpacing
        }
        
        if let padding = aDelegate?.padding?(in: self) {
            self.padding = padding
        }
        
        unitLength = itemLength + itemSpacing
    }
    
    var multiple: Int {
        
        if isInfiniteScrollingEnabled {
            let ratio = Int(ceil(boundLength/unitLength))
            return ratio * 3
        }else {
            return 1
        }
    }
    
    var itemSize: CGSize {
        
        if layout.scrollDirection == .horizontal {
            let height = bounds.height - 2 * padding
            return CGSize(width: itemLength, height: height)
        }else {
            let width = bounds.width - 2 * padding
            return CGSize(width: width, height: itemLength)
        }
    }
    
    var insets: UIEdgeInsets {
    
        if layout.scrollDirection == .horizontal {
            return UIEdgeInsetsMake(padding, itemSpacing, padding, itemSpacing)
        }else {
            return UIEdgeInsetsMake(itemSpacing, padding, itemSpacing, padding)
        }
    }
    
    var scrollLength: CGFloat {
        
        if layout.scrollDirection == .horizontal {
            return contentSize.width
        }else {
            return contentSize.height
        }
    }
    
    var boundLength: CGFloat {
        
        if layout.scrollDirection == .horizontal {
            return bounds.size.width
        }else {
            return bounds.size.height
        }
    }
    
    var offset: CGFloat {
        
        get {
            if layout.scrollDirection == .horizontal {
                return contentOffset.x
            } else {
                return contentOffset.y
            }
        }
        set {
            if layout.scrollDirection == .horizontal {
                contentOffset.x = newValue
            } else {
                contentOffset.y = newValue
            }
        }
    }
    
    func setOffset(offset: CGFloat, animated: Bool) {
        
        var contentOffset = self.contentOffset
        if layout.scrollDirection == .horizontal {
            contentOffset.x = offset
        } else {
            contentOffset.y = offset
        }
        setContentOffset(contentOffset, animated: animated)
    }
    
    func resetContentOffsetIfNeeded() {
        
        guard isInfiniteScrollingEnabled else {
            return
        }
        
        guard rows >= 2 else {
            return
        }

        let topThreshold: CGFloat = 0
        let bottomThreshold: CGFloat = scrollLength - boundLength
        
        guard bottomThreshold > topThreshold else {
            return
        }
        
        var y = offset
        
        if y < topThreshold {
            y += unitLength * CGFloat(rows) * CGFloat(multiple/2)
            offset = y
        }else if y > bottomThreshold {
            y -= unitLength * CGFloat(rows) * CGFloat(multiple/2)
            offset = y
        }
    }
}

