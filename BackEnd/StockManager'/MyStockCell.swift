//
//  MyStockCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class MyStockCell: UITableViewCell, Reusable {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var warehouse: Warehouse! {
        didSet {
            productNameLabel.text = warehouse.product?.name
            stockLabel.text = "虚拟库存数：\(warehouse.stock)件"
        }
    }
    
    @IBAction func clickCheckoutButton(sender: Any) {
        let stockView = StockView.loadFromNib()
        stockView.warehouse = warehouse
        stockView.show()
    }
}
