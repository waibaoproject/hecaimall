//
//  DeliveryManagerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import PageViewController

class DeliveryManagerViewController: UIViewController, FromBackendStoryboard {
    
    var partner: Partner?
    
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["我的出货订单", "下级出货订单"]
            
            let normalColor = UIColor(hex: 0x595757)!
            let selectedColor = UIColor(hex: 0xD22222)!
            
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
    
    private lazy var pageViewController: PageViewController = { [unowned self] in
        
        let controller1 = MyDeliveryViewController()
        controller1.api = NextableAPIPath(path: "/partners/\(self.partner?.id ?? "")/orders")
        let controller2 = XiajiDeliveryViewController()
        
        let controllers = [controller1, controller2]
        controllers.forEach({
            $0.automaticallyAdjustsScrollViewInsets = false
        })
        let controller = PageViewController(controllers: controllers)
        controller.didScrollToIndex = {
            self.segmentedControl.selectedSegmentIndex = $0
        }
        return controller
        }()
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "出货管理"
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = containerView.bounds
    }
}

