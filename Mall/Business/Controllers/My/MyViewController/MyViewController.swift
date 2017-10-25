//
//  MyViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import WebImage
import NavigationBarExtension

class MyViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var favoriteAndViewedGridView: FavoriteAndViewedGridView!
    
    private let disposeBag = DisposeBag()
    
    private var user: User?
    private var unreadCount: MessageCount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarBackgroundAlpha = 0.0
        navigationBarShadowImageHidden = true
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 20, right: 0)
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUser()
        loadMessageCount()
    }
    
    private func reloadData() {
        
        if let user = user {
            avatarImageView.web.setImage(with: user.avatar, placeholder: UIImage(asset: .defaultAvatar))
            nickNameLabel.text = user.nickname
        } else {
            avatarImageView.web.setImage(with: nil, placeholder: UIImage(asset: .defaultAvatar))
            nickNameLabel.text = "请登陆"
        }
        favoriteAndViewedGridView.messageCount = unreadCount
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    private func loadUser() {
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: APIPath(path: "/user")).response(accessory: loading)
            .subscribe(onNext: { [weak self] (data: User) in
                guard let `self` = self else {return}
                self.user = data
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadMessageCount() {
        if LoginCenter.default.isLogin {
//            let loading = LoadingAccessory(view: self.view)
            DefaultDataSource(api: APIPath(path: "/user/message_counts")).response(accessory: nil)
                .subscribe(onNext: { [weak self] (data: MessageCount) in
                    self?.unreadCount = data
                    self?.reloadData()
                })
                .disposed(by: self.disposeBag)
        } else {
            self.unreadCount = nil
            self.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}

extension MyViewController {
    
    @IBAction func clickSettingButton(sender: Any) {
        let controller = SettingTableViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        controller.didLogout = { [weak self] in
            self?.user = nil
            self?.reloadData()
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickAvatarButton(sender: Any) {
        guard LoginCenter.default.isLogin else {
            LoginCenter.default.forceLogin()
            return
        }
        let controller = ProfileViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
