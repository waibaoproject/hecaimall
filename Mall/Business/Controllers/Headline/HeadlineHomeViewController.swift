//
//  HeadlineHomeViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import PageViewController

class HeadlineHomeViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["最新资讯", "资讯推荐"]
            
            let normalColor = UIColor(hex: 0x595757)!
            let selectedColor = UIColor(hex: 0xDC2727)!
            
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalColor], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
            
            segmentedControl.segmentBackgroundView = {
                Slider(isSelected: $0, color: selectedColor, size: CGSize(width: 0, height: 2))
            }
            
            segmentedControl.didSelect = { [unowned self] in
                self.pageViewController.scrollToIndex(index: $0)
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    private lazy var latest: HeadlinesViewController = {
        let controller = HeadlinesViewController()
        controller.automaticallyAdjustsScrollViewInsets = false
        controller.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        controller.dataSource = DefaultNextableArrayDataSource(api: NextableAPIPath(path: "/headlines/newest"))
        return controller
    }()
    
    private lazy var recommaned: HeadlinesViewController = {
        let controller = HeadlinesViewController()
        controller.automaticallyAdjustsScrollViewInsets = false
        controller.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        controller.dataSource = DefaultNextableArrayDataSource(api: NextableAPIPath(path: "/headlines/recommend"))
        return controller
    }()
    
    private lazy var pageViewController: PageViewController = {
        let controller = PageViewController(controllers: [latest, recommaned])
        controller.didScrollToIndex = { [unowned self] in
            self.segmentedControl.selectedSegmentIndex = $0
        }
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
    }
}
