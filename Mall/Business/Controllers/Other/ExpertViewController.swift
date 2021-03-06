//
//  ExpertViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import PageViewController

class ExpertViewController: UIViewController, FromOtherStroyboard {
    
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["咨询列表", "咨询问题"]
            
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
    
    private lazy var pageViewController: PageViewController = { [unowned self] in
        
        let controller1 = QuestionsViewController.instantiate()
        let controller2 = AskExpertViewController.instantiate()
        
        
        let controllers = [controller1, controller2]
        controllers.forEach({
            $0.automaticallyAdjustsScrollViewInsets = false
        })
        let controller = PageViewController(controllers: controllers)
        controller.didScrollToIndex = {
            self.segmentedControl.selectedSegmentIndex = $0
        }
        
        controller2.didSubmit = { [weak controller] in
            controller?.scrollToIndex(index: 0)
            controller1.tableView.startPullRefresh()
        }

        return controller
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "专家咨询"
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = containerView.bounds
    }
}
