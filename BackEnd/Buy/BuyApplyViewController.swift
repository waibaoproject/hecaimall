//
//  BuyApplyViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import PageViewController
import RxSwift

class BuyApplyViewController: UIViewController, FromBuyStoryboard {
    
//    private var partner: Partner?
    
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["线上采购", "线下采购"]
            
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
    
    private lazy var controller1 = OnlineApplyViewController.instantiate()
    private lazy var controller2 = OfflineApplyViewController.instantiate()
    
    private lazy var pageViewController: PageViewController = { [unowned self] in
        
        let controllers: [UIViewController] = [self.controller1, self.controller2]
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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "采购申请"
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        
        let api = APIPath(path: "/user/partner")
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: Partner) in
            guard let `self` = self else {return}
//            self.partner = data
            self.controller1.partner = data
            self.controller2.partner = data
//            (self.pageViewController.viewControllers?[0] as? OnlineApplyViewController)?.partner = data
//            (self.pageViewController.viewControllers?[1] as? OfflineApplyViewController)?.partner = data
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = containerView.bounds
    }
    
}

