//
//  HeadlinesViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
//import PKHUD

class HeadlinesViewController: UITableViewController {
    
    private var headlines: [Headline] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var dataSource: NextableArrayDataSource?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.register(cellType: HeadlineCell.self)
        
        tableView.addPullRefresh { [weak self] in
            self?.loadFirst()
        }
        
        tableView.addPushRefresh { [weak self] in
            self?.loadMore()
        }
        
    }
    
    private var isFristTimeToLoad: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFristTimeToLoad {
            tableView.startPullRefresh()
            isFristTimeToLoad = false
        }
    }
    
    private func loadFirst() {
        dataSource = dataSource?.first()
        loadMore()
    }

    private func loadMore() {
        
        (dataSource!.response(accessory: RefreshAccessory(view: tableView)))
            .catchErrorWithComplete(handler: { [weak self] error in
                guard let `self` = self else {return}
                self.view.toast(error.localizedDescription)
            })
            .subscribe(onNext: { [weak self] (headlines: [Headline]) in
                guard let `self` = self else {return}
                if self.dataSource!.isFirst {
                    self.headlines = headlines
                } else {
                    self.headlines += headlines
                }
                self.dataSource = self.dataSource?.next()
            })
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as HeadlineCell
        cell.headline = headlines[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = HeadlineViewController()
        controller.id = headlines[indexPath.row].id
        controller.hidesBottomBarWhenPushed = true
        controller.url = headlines[indexPath.row].link
        navigationController?.pushViewController(controller, animated: true)
    }
}



