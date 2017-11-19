//
//  OrdersViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/3.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import PageViewController


class OrdersIndexViewController: UIViewController, FromOrderStoryboard {

    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["全部", "待支付", "待发货", "待收货", "待评价"]
            
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
    
    var initialIndex: Int = 0
    
    private lazy var pageViewController: PageViewController = { [unowned self] in
        
        let controller1 = OrdersViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        controller1.ordersCountChanged = { [weak self] in
//            self?.segmentedControl.updateItem("全部(\($0))", atIndex: 0)
//        }
        
        let controller2 = OrdersViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller2.orderState = .waitForPay
//        controller2.ordersCountChanged = { [weak self] in
//            self?.segmentedControl.updateItem("待支付(\($0))", atIndex: 1)
//        }

        let controller3 = OrdersViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller3.orderState = .waitForDeliver
//        controller3.ordersCountChanged = { [weak self] in
//            self?.segmentedControl.updateItem("待发货(\($0))", atIndex: 2)
//        }
        
        let controller4 = OrdersViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller4.orderState = .waitForReceive
//        controller4.ordersCountChanged = { [weak self] in
//            self?.segmentedControl.updateItem("待收货(\($0))", atIndex: 3)
//        }
        
        let controller5 = OrdersViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller5.orderState = .end
//        controller5.ordersCountChanged = { [weak self] in
//            self?.segmentedControl.updateItem("待评价(\($0))", atIndex: 4)
//        }
        
        let controllers = [controller1, controller2, controller3, controller4, controller5]
        controllers.forEach({
            $0.automaticallyAdjustsScrollViewInsets = false
        })
        let controller = PageViewController(controllers: controllers)
        controller.didScrollToIndex = {
            self.segmentedControl.selectedSegmentIndex = $0
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        
        segmentedControl.selectedSegmentIndex = initialIndex
        pageViewController.scrollToIndex(index: initialIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = containerView.bounds
    }
}
