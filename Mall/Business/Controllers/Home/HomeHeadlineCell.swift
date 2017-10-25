//
//  HomeHeadlineCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Reusable
import SnapKit
import FoundationExtension
import InfiniteScrollingView

class HomeHeadlineCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var infiniteScrollingView: InfiniteScrollingView! {
        didSet {
            infiniteScrollingView.register(cellType: HomelineSnapshot.self)
            infiniteScrollingView.aDataSource = self
            Timer.every(interval: 3, target: self) { _ in
                self.infiniteScrollingView.scrollToNext()
            }
        }
    }

    var headlines: [Headline] = [] {
        didSet {
            infiniteScrollingView.reloadData()
        }
    }
}

extension HomeHeadlineCell: InfiniteScrollingViewDataSource {
    func numberOfItems(in infiniteScrollingView: InfiniteScrollingView) -> Int {
        return headlines.count
    }
    
    func infiniteScrollingView(_ infiniteScrollingView: InfiniteScrollingView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = infiniteScrollingView.dequeueReusableCell(withReuseIdentifier: HomelineSnapshot.reuseIdentifier, for: index) as! HomelineSnapshot
        cell.headline = headlines[index]
        return cell
    }
}

fileprivate class HomelineSnapshot: UICollectionViewCell, Reusable {
    
    private lazy var label: UILabel = { [unowned self] in
        let label = UILabel()
        label.setupConfig(TitleLabelConfige())
        label.isUserInteractionEnabled = true
        
        self.addSubview(label)
        label.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickLabel(sender:)))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    var headline: Headline! {
        didSet {
            label.text = headline?.title
        }
    }
    
    @objc func clickLabel(sender: Any) {
        let controller = HeadlineViewController()
        controller.id = headline.id
        
        controller.hidesBottomBarWhenPushed = true
        controller.url = headline?.link
        parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
