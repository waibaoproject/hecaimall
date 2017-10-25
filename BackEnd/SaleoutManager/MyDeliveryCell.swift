//
//  MyDeliveryCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class MyDeliveryCell: UITableViewCell, NibReusable, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var sumaryLabel: UILabel!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    static func cellHeight(order: Order) -> CGFloat {
        let tableViewHeight: Int = (order.items.count * (60 + 2) - 2)
        let height = 25 + 2 + tableViewHeight + 2 + 65
        return CGFloat(height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.isScrollEnabled = false
        tableView.register(cellType: MyDeliveryOrderProductCell.self)
    }
    
    var order: Order! {
        didSet {
            orderNumLabel.text = order.number
            createTimeLabel.text = order.createDate?.toString(by: "yyyy-MM-dd HH:mm")
            let count = order.items.reduce(0) {
                return $0 + $1.count
            }
            sumaryLabel.text = "共\(count)件商品 合计\(order.totalPayment.display)"
            partnerNameLabel.text = order.partnerName
        }
    }
    
    @IBAction func clickDetailButton(sender: Any) {
        // TODO:
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return order.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MyDeliveryOrderProductCell
        cell.item = order.items[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
}

class MyDeliveryOrderProductCell: UITableViewCell, NibReusable {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var item: ProductItem! {
        didSet {
            productNameLabel.text = item.product.name
            productTypeLabel.text = "类型: \(String(describing: item.product.type))"
            priceLabel.text = item.product.price.display
            countLabel.text = "x\(item.count)"
        }
    }
}

