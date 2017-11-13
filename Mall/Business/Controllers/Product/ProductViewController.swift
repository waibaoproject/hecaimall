//
//  ProductViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/30.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import SegmentedControl
import PageViewController
import FoundationExtension

class ProductViewController: UIViewController, FromProductStoryboard {
    
    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
            segmentedControl.tintColor = .clear
            segmentedControl.items = ["商品", "详情", "评价"]
            
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
    
    private lazy var pageViewController: PageViewController = { [unowned self] in
        let controller = PageViewController(controllers: [self.detail, self.imageDesc, self.comment])
        controller.didScrollToIndex = {
            self.segmentedControl.selectedSegmentIndex = $0
        }
        return controller
        }()
    
    var product: Product? {
        didSet {
            detail.product = product
            imageDesc.url = product?.detailURL
        }
    }
    
    private lazy var detail: ProductDetailViewController = {
        let controller = ProductDetailViewController.instantiate()
        controller.didPushRefresh = { [weak self] in
            self?.pageViewController.scrollToIndex(index: 1)
            self?.segmentedControl.selectedSegmentIndex = 1
        }
        return controller
    }()
    
    private lazy var imageDesc: WebViewController = {
        let controller = WebViewController()
        return controller
    }()
    
    private lazy var comment: ProductCommentsViewController = {
        let controller = ProductCommentsViewController.instantiate()
        controller.productId = product?.id ?? ""
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = view.bounds
    }
    
    @IBAction func clickCartButton(sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        delay(time: 0.1) {
            (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.selectedIndex = 3
        }
        
    }
}

