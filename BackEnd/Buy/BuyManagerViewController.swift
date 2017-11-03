//
//  BuyManagerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/26.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

class BuyManagerViewController: UIViewController, FromBuyStoryboard {
    
    var partner: Partner?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clickApplyButton(sender: Any) {
        let controller = BuyApplyViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickOrderButton(sender: Any) {
        
    }

}
