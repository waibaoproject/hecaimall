//
//  HealthViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/12.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class HealthViewController: UITableViewController, FromMyStoryboard {
    
    private var healths: [KeyValue] = []
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "健康信息"
        loadUser()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return healths.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as HealthKeyValueCell
        let map = healths[indexPath.section]
        cell.health = map
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = healths[indexPath.section].key
        guard let values = HeathDataManager.shared.data[key] else {return}
        let view = ItemsSelectionView()
        view.items = values
        view.selected = { [weak self] (value, index) in
//            let codedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            self?.modifyUser(parameters: ["healths[\(key)]": value])
        }
        view.showAsPicker(height: 250)
    }
    
    private func loadUser() {
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: APIPath(path: "/user")).response(accessory: loading)
            .subscribe(onNext: { [weak self] (data: User) in
                guard let `self` = self else {return}
                self.healths = data.healths
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func modifyUser(parameters: [String: Any]) {
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: APIPath(method: .put, path: "/user", parameters: parameters))
            .response(accessory: loading)
            .subscribe(onNext: { (data: User) in
                self.healths = data.healths
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

