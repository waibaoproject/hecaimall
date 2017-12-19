//
//  ProcurementOrderListViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class ProcurementOrderListViewController: UITableViewController, FromBuyStoryboard {

    private var items: [ProcurementOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isXiaji: Bool = false
    var isOnline: Bool = true
    
    private let disposeBag = DisposeBag()
    
    private var api: NextableAPIPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path: String = {
            if isXiaji {
                return "/subordinate/procurement/orders"
            } else {
                return "/user/procurement/orders"
            }
        }()
        let type: String = {
            if isOnline {
                return "online"
            } else {
                return "offline"
            }
        }()
        api = NextableAPIPath(path: path, parameters: ["type": type])
        
        tableView.addPullRefresh { [weak self] in
            self?.reloadItems()
        }
        
        tableView.addPushRefresh { [weak self] in
            self?.loadItems()
        }

        delay(time: 0.3) {
            self.tableView.startPullRefresh()
        }
    }
    
    private func reloadItems() {
        api = api.first()
        loadItems()
    }
    
    private func loadItems() {
        let loading = RefreshAccessory(view: tableView)
        DefaultNextableArrayDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: [ProcurementOrder]) in
            guard let `self` = self else {return}
            self.items = self.api.isFirst ? data : self.items + data
            self.api = self.api.next()
        }).disposed(by: disposeBag)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProcurementOrderCell
        cell.order = (isXiaji, items[indexPath.section])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProcurementOrderCell.cellHeight(order: (isXiaji: isXiaji, order: items[indexPath.section]))
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isXiaji else {return}
        let order = items[indexPath.section]
        if order.state == .waitForProcess && order.isAudit {
            let controller = UnhandledOrderViewController.instantiate()
            controller.order = items[indexPath.section]
            controller.didHandle = { [weak self] in
                self?.tableView.startPullRefresh()
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
