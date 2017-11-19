//
//  SettingTableViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/14.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage

class SettingTableViewController: UITableViewController, FromOtherStroyboard {
    
    var didLogout: (() ->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DefaultImageCache.shared.clearCache()
            view.toast("清理缓存成功")
        }
    }
    
    @IBAction func clickLogoutButton(sender: Any) {
        LoginCenter.default.logout()
        view.toast("退出登录成功")
        navigationController?.popViewController(animated: true)
        didLogout?()
    }
}
