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
//import NavigationBarExtension

class MyViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var partnerButton: UIButton!
    
    @IBOutlet weak var favoriteAndViewedGridView: FavoriteAndViewedGridView!
    
    private let disposeBag = DisposeBag()
    
    private var user: User?
    private var unreadCount: MessageCount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 20, right: 0)
        
        partnerButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        loadUser()
        loadMessageCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .darkGray
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
    
    @IBAction func clickPartnerButton(sender: Any) {
        let controller = BackendHomeViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
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
                self.partnerButton.isHidden = !data.isAdmin
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadMessageCount() {
        if LoginCenter.default.isLogin {
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
