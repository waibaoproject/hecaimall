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
import RxSwift

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
    
    private let disposeBag = DisposeBag()
    
    var qrcode: String? {
        didSet {
            detail.qrcode = qrcode
        }
    }
    
    var product: Product? {
        didSet {
            detail.product = product
            imageDesc.url = product?.detailURL
//            imageDesc.url = URL(string: "http://image.baidu.com/search/index?tn=baiduimage&ct=201326592&lm=-1&cl=2&ie=gbk&word=%CD%BC%C6%AC&fr=ala&ala=1&alatpl=others&pos=0")
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
        controller.progressView.isHidden = true
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
        pageViewController.view.frame = view.bounds
//        if let _ = qrcode {
//            let controller = UIAlertController(title: nil, message: "请点击【立即购买】，直接完成下单支付，否则此次操作无效。", preferredStyle: .alert)
//            let action = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.default, handler: nil)
//            controller.addAction(action)
//            present(controller, animated: true, completion: nil)
//        }
        
        let productId = product?.id ?? "1Q4lvkrZV5"
        DefaultDataSource(api: APIPath(path: "/product/view/id/\(productId)")).response(accessory: LoadingAccessory(view: view))
            .subscribe(onNext: { [weak self] (data: Product) in
                guard let `self` = self else {return}
                self.product = data
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }

    
    deinit {
        print("\(self) deinit")
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

