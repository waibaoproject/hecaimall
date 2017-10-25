//
//  GroupSelectView.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import SwiftHEXColors
import SnapKit

class GroupSelectView: UIView {

    private lazy var tableView: UITableView = {[unowned self] in
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.register(cellType: GroupSelectCell.self)
        self.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    var items: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    var didSelect: ((Int) -> Void)?
}

extension GroupSelectView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GroupSelectCell
        cell.label.text = items[indexPath.row]
        cell.label.textColor = selectedIndex == indexPath.row ? UIColor(hex: 0xDC2727) : UIColor(hex: 0x595757)
        return cell
    }
}

extension GroupSelectView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        didSelect?(indexPath.row)
    }
}

fileprivate class GroupSelectCell: UITableViewCell, Reusable {
    fileprivate lazy var label: UILabel = { [unowned self] in
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.textAlignment = .center
        self.addSubview(view)
        self.selectionStyle = .none
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        return view
    }()
}
