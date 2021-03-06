//
//  BusinessLayerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import PullRefresh
import FoundationExtension

class BusinessLayerViewController: UIViewController, FromBackendStoryboard, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var api = NextableAPIPath(path: "/partners")
    
    private var items: [Partner] = []
    
    private let disposeBag = DisposeBag()
    
    var merchantType: MerchantType = .normal

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "业务层管理" 
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
                self.api = self.api.next()
            })
        .disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as PartnerCell
        cell.partner = items[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
        
    }

    @IBAction func clickAddPartnerButton(sender: Any) {
        
        guard merchantType == .normal else {
            view.toast("您无权限操作该功能")
            return
        }

        let controller = AddPartnerViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
