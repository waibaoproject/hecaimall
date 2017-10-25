//
//  HeadlineViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/17.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import RxSwift

class HeadlineViewController: WebViewController {
    
    var id: String = ""
    
    private var headline: Headline?
    
    private let dispose = DisposeBag()
    
    private lazy var favorteButton: UIButton = { [unowned self] in
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(asset: .unfavorited), for: .normal)
        button.setImage(UIImage(asset: .favorited), for: .selected)
        button.addTarget(self, action: #selector(clickFavoriteButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favariteItem = UIBarButtonItem(customView: favorteButton)
        let shareItem = UIBarButtonItem(image: UIImage(asset: .share), style: .plain, target: self, action: #selector(clickShareButton(sender:)))

        navigationItem.rightBarButtonItems = [favariteItem, shareItem]
        
        let api = APIPath(method: .post, path: "/headlines/footPrint/id/\(id)")
        DefaultDataSource(api: api).response(accessory: nil).subscribe(onNext: { (data: Headline) in
            self.headline = data
            self.favorteButton.isSelected = data.isFavorited
        }).disposed(by: dispose)
    }
    
    
    @objc func clickFavoriteButton(sender: Any) {
        guard let headline = headline else {return}
        guard LoginCenter.default.isLogin else {
            LoginCenter.default.forceLogin()
            return
        }
        let loading = LoadingAccessory(view: view)
        if headline.isFavorited {
            let api = APIPath(method: .delete, path: "/user/favHeadlines/id/\(id)")
            responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: {
                self.headline?.isFavorited = false
                self.favorteButton.isSelected = false
                self.view.noticeOnlyText("取消收藏成功")
            }).disposed(by: dispose)
        } else {
            let api = APIPath(method: .post, path: "/user/favHeadlines/id/\(id)")
            responseVoid(accessory: loading, urlRequest: api).subscribe(onNext: {
                self.headline?.isFavorited = true
                self.favorteButton.isSelected = true
                self.view.noticeOnlyText("收藏成功")
            }).disposed(by: dispose)
        }
    }
    
    @objc func clickShareButton(sender: Any) {
        
    }
}
