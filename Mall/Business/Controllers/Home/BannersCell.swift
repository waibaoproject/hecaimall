//
//  BannersCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//


import Reusable
import WebImage
import FoundationExtension
import RxSwift
import InfiniteScrollingView

protocol AsBanner {
    var image: URL? {get}
    var link: URL? {get}
}

class BannersCell: UITableViewCell, Reusable {
    
    private(set) lazy var pageView: InfiniteScrollingView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = InfiniteScrollingView(frame: .zero, collectionViewLayout: layout)
        view.register(cellType: BannerCell.self)
        view.backgroundColor = .white
        view.aDataSource = self
        view.aDelegate = self
        view.isPagingEnabled = true
        Timer.every(interval: 3, target: self) { _ in
            view.scrollToNext()
        }
        view.didScrollAt = { [weak self] in
            self?.pageIndicatorView.currentPage = $0
        }
        
        self.addSubview(view)
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        return view
        }()
    
    var linkable: Bool = true
    
    private lazy var pageIndicatorView: UIPageControl = { [unowned self] in
        let view = UIPageControl()
        self.addSubview(view)
        view.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(15)
        })
        return view
    }()
    
    var banners: [AsBanner] = [] {
        didSet {
            pageView.reloadData()
            pageIndicatorView.numberOfPages = banners.count
            pageIndicatorView.currentPage = 0
        }
    }
}

extension BannersCell: InfiniteScrollingViewDataSource {
    func numberOfItems(in infiniteScrollingView: InfiniteScrollingView) -> Int {
        return banners.count
    }
    func infiniteScrollingView(_ infiniteScrollingView: InfiniteScrollingView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = infiniteScrollingView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: index)  as! BannerCell
        cell.banner = banners[index]
        return cell
    }
}

extension BannersCell: InfiniteScrollingViewDelegate {
    func infiniteScrollingView(_ infiniteScrollingView: InfiniteScrollingView, didSelectItemAt index: Int) {
        guard linkable else {return}
        let controller = WebViewController()
        controller.hidesBottomBarWhenPushed = true

        controller.url = banners[index].link
        parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
}

fileprivate class BannerCell: UICollectionViewCell, Reusable {
    
    private lazy var imageView: UIImageView = { [unowned self] in
        let view = UIImageView()
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.backgroundColor = UIColor(hex: 0xF4F4F4)
        return view
        }()
    
    private let disposeBag = DisposeBag()
    
    var banner: AsBanner? {
        didSet {
            imageView.web.setImage(with: banner?.image)
        }
    }
}

