//
//  ProductCommentsViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/30.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import PageViewController

class ProductCommentsViewController: UIViewController, FromProductStoryboard {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var onlyImageButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    var productId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        
        allButton.alpha = 1
        onlyImageButton.alpha = 0.5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = containerView.bounds
    }
    
    @IBAction func clickAllButton(sender: Any) {
        allButton.alpha = 1
        onlyImageButton.alpha = 0.5
        pageViewController.scrollToIndex(index: 0)
    }
    
    @IBAction func clickOnlyImageButton(sender: Any) {
        allButton.alpha = 0.5
        onlyImageButton.alpha = 1
        pageViewController.scrollToIndex(index: 1)
    }

    private lazy var pageViewController: PageViewController = { [unowned self] in
        
        let controller1 = CommentsViewController.instantiate()
        controller1.productId = productId
        let controller2 = CommentsViewController.instantiate()
        controller2.productId = productId
        controller2.isOnlyImage = true
        let controllers = [controller1, controller2]
        controllers.forEach({
            $0.automaticallyAdjustsScrollViewInsets = false
        })
        let controller = PageViewController(controllers: controllers)
        controller.isScrollEnabled = false
        return controller
        }()
}
