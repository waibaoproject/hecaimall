//
//  BackendHomeViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/16.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

class BackendHomeViewController: UIViewController, FromMainStoryboard {
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarBackgroundImage = UIImage()
        navigationBarShadowImageHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSettingButton(sender: Any) {
        
    }
    
    @IBAction func clickMessageButton(sender: Any) {
        
    }
    
    @IBAction func clickShareButton(sender: Any) {
        
    }
    
    @IBAction func clickBusinessButton(sender: Any) {
        let controller = BusinessManagerViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickStockButton(sender: Any) {
        
    }

    @IBAction func clickDeliveryButton(sender: Any) {
        
    }

    @IBAction func clickBuyButton(sender: Any) {
        
    }

    @IBAction func clickCaculateButton(sender: Any) {
        
    }
}


