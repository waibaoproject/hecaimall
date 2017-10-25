//
//  ProductCommentViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/11.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import RxSwift

class ProductCommentViewController: UIViewController, FromProductStoryboard {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var rate1Button: UIButton!
    @IBOutlet weak var rate0Button: UIButton!
    @IBOutlet weak var rate_1Button: UIButton!

    @IBOutlet weak var contentTextView: PlaceholderTextView!
    @IBOutlet weak var imagePickerView: ImagePickerView!
    
    @IBOutlet weak var salerRatingView: SwiftyStarRatingView!
    @IBOutlet weak var deliverRatingView: SwiftyStarRatingView!
    
    @IBOutlet weak var isAnonymousButton: UIButton!
    
    var orderId: String!
    var product: Product!
    
    private var rating: Int = 1
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.keyboardDismissMode = .interactive
        coverImageView.web.setImage(with: product.cover)
        reloadData()
    }
    
    func reloadData() {
        rate1Button.isSelected = rating == 1
        rate0Button.isSelected = rating == 2
        rate_1Button.isSelected = rating == 3
    }
    
    @IBAction func clickRate1Button(sender: Any) {
        rating = 1
        reloadData()
    }
    
    @IBAction func clickRate0Button(sender: Any) {
        rating = 2
        reloadData()
    }
    
    @IBAction func clickRate_1Button(sender: Any) {
        rating = 3
        reloadData()
    }
    
    @IBAction func clickIsanonymousButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickSubmitButton(sender: Any) {
        let content = contentTextView.text
        guard !content.isNilOrBlankString else {
            view.noticeOnlyText("请输入商品评价")
            return
        }
        
        let images = imagePickerView.images.filter { $0.size != .zero }
        let codes = images.flatMap({
            $0.wxCompress().data?.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        })
        let codesString = codes.joined(separator: ",")
        
        let parameters: [String: Any] = ["order_id": orderId, "rating": rating, "content": content!, "images": codesString]
        
        let api = APIPath(method: .post, path: "/product/comments/id/\(product.id)", parameters: parameters)
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading)
            .subscribe(onNext: { [weak self] (data: ProductComment) in
                self?.noticeOnlyText("评价成功")
                self?.navigationController?.popViewController(animated: true)
            })
        .disposed(by: disposeBag)
    }
}
