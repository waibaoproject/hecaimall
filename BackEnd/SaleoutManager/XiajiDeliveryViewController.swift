//
//  XiajiDeliveryViewController.swift
//  Mall/Users/wangxiaotao/Documents/Sometimes/Mall/BackEnd/SaleoutManager
//
//  Created by 王小涛 on 2017/10/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import PullRefresh
import FoundationExtension

class XiajiDeliveryViewController: UITableViewController {
    
    private var api = NextableAPIPath(path: "/order/partners")
    
    private var items: [Partner] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellType: XiajiDeliveryCell.self)
        
        tableView.addPullRefresh { [weak self] in
            guard let `self` = self else {return}
            self.api = self.api.first()
            self.loadData()
        }
        
        tableView.addPushRefresh { [weak self] in
            guard let `self` = self else {return}
            self.loadData()
        }
        
        delay(time: 0.3) {
            self.tableView.startPullRefresh()
        }
    }
    
    private func loadData() {
        let refresh = RefreshAccessory(view: tableView)
        DefaultNextableArrayDataSource(api: api).response(accessory: refresh)
            .subscribe(onNext: {[weak self] (data: [Partner]) in
                guard let `self` = self else {return}
                self.items = self.api.isFirst ? data : self.items + data
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as XiajiDeliveryCell
        cell.partner = items[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return XiajiDeliveryCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
}
