//
//  CommentsViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class CommentsViewController: UITableViewController, FromProductStoryboard {
    
    private var comments: [ProductComment] = []
    
    var isOnlyImage: Bool = false
    
    var productId: String = ""
    
    private var api: NextableAPIPath!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false

        api = NextableAPIPath(path: "/product/commentList/id/\(productId)")
     
        tableView.addPullRefresh { [weak self] in
            guard let `self` = self else {return}
            self.api = self.api.first()
            self.loadData()
        }
        
        tableView.addPushRefresh { [weak self] in
            guard let `self` = self else {return}
            self.loadData()
        }
        
        delay(time: 0.5) {
            self.tableView.startPullRefresh()
        }

    }
    
    private func loadData() {
        let accessory = RefreshAccessory(view: tableView)
        DefaultNextableArrayDataSource(api: api).response(accessory: accessory)
            .subscribe(onNext: {[weak self] (data: [ProductComment]) in
                guard let `self` = self else {return}
                if self.api.isFirst {
                    self.comments = data
                } else {
                    self.comments += data
                }
                self.tableView.reloadData()
            })
        .disposed(by: disposeBag)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CommentCell
        cell.comment = comments[indexPath.section]
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let comment = comments[indexPath.section]
        let size = CGSize(width: tableView.bounds.width - 40, height: 999)
        let contentHeight = (comment.content as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil).height
        
        var totoalHeight = 42 + 15 + contentHeight + 15
        
        
        if comment.images.count > 0 {
            totoalHeight += (80 + 15)
        }
        return totoalHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
