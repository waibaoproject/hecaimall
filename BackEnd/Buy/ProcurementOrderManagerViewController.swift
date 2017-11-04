//
//  ProcurementOrderManagerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import PageViewController

class ProcurementOrderManagerViewController: UIViewController, FromBuyStoryboard {
    
    @IBOutlet weak var onlinePayButton: UIButton!
    @IBOutlet weak var offlinePayButton: UIButton!
    
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["我的采购申请", "下级的采购申请"]
            
            let normalColor = UIColor(hex: 0x595757)!
            let selectedColor = UIColor(hex: 0xD22222)!
            
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalColor], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
            
            segmentedControl.segmentBackgroundView = {
                Slider(isSelected: $0, color: selectedColor, size: CGSize(width: 0, height: 2))
            }
            
            segmentedControl.didSelect = { [unowned self] _ in
                self.transition(from: self.currentController, to: self.selectedController)
            }
        }
    }
        
    @IBOutlet weak var containerView: UIView!
    
    private var currentController: ProcurementOrderListViewController!
    
    private lazy var controller1: ProcurementOrderListViewController = {
        // 上级 线上
        let controller = ProcurementOrderListViewController.instantiate()
        controller.isXiaji = false
        controller.isOnline = true
        return controller
    }()
    
    private lazy var controller2: ProcurementOrderListViewController = {
        // 上级 线下
        let controller = ProcurementOrderListViewController.instantiate()
        controller.isXiaji = false
        controller.isOnline = false
        return controller
    }()

    private lazy var controller3: ProcurementOrderListViewController = {
        // 下级 线上
        let controller = ProcurementOrderListViewController.instantiate()
        controller.isXiaji = true
        controller.isOnline = true
        return controller
    }()

    
    private lazy var controller4: ProcurementOrderListViewController = {
        // 下级 线下
        let controller = ProcurementOrderListViewController.instantiate()
        controller.isXiaji = true
        controller.isOnline = false
        return controller
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "采购订单"
        addChildViewController(controller1)
        addChildViewController(controller2)
        addChildViewController(controller3)
        addChildViewController(controller4)
        
        containerView.addSubview(controller1.view)
        currentController = controller1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controller1.view.frame = containerView.bounds
        controller2.view.frame = containerView.bounds
        controller3.view.frame = containerView.bounds
        controller4.view.frame = containerView.bounds
    }
    
    private var selectedController: ProcurementOrderListViewController {
        if segmentedControl.selectedSegmentIndex == 0 && onlinePayButton.isSelected {
            return controller1
        } else if segmentedControl.selectedSegmentIndex == 0 && !onlinePayButton.isSelected {
            return controller2
        } else if segmentedControl.selectedSegmentIndex == 1 && onlinePayButton.isSelected {
            return controller3
        } else {
            return controller4
        }
    }

    @IBAction func clickOnlinePayButton(sender: Any) {
        onlinePayButton.isSelected = true
        offlinePayButton.isSelected = false
        transition(from: currentController, to: selectedController)
    }
    
    @IBAction func clickOfflinePayButton(sender: Any) {
        onlinePayButton.isSelected = false
        offlinePayButton.isSelected = true
        transition(from: currentController, to: selectedController)
    }
    
    private func transition(from: ProcurementOrderListViewController, to: ProcurementOrderListViewController) {
        guard from != to else {return}
        transition(from: from, to: to, duration: 0.01, options: .curveEaseInOut, animations: nil) { (finished) in
            if finished {
                to.didMove(toParentViewController: self)
                self.currentController = to
                to.view.frame = self.containerView.bounds
            } else {
                self.currentController = from
            }
        }
    }
}
