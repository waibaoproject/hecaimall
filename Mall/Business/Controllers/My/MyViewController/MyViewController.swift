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
import FoundationExtension

class MyViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var partnerButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var favoriteAndViewedGridView: FavoriteAndViewedGridView!
    @IBOutlet weak var orderGridView: OrderGridView!
    
    private let disposeBag = DisposeBag()
    
    private var user: User?
    private var unreadCount: MessageCount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 20, right: 0)
        partnerButton.isHidden = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        view.backgroundColor = .clear
        tableView.tableFooterView = view
        PushCountManager.shared.count.asObservable().subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (count) in
            self?.messageButton?.markType = .dot
            self?.messageButton?.markValue = count == 0 ? nil : "\(count)"
        }).addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        PushCountManager.shared.update()

//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        if LoginCenter.default.isLogin {
            loadUser()
            loadMessageCount()
        } else {
            user = nil
            unreadCount = nil
            reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
    
    private func reloadData() {
        
        if let user = user {
            partnerButton.isHidden = !user.isAdmin
            avatarImageView.web.setImage(with: user.avatar, placeholder: UIImage(asset: .defaultAvatar))
            nickNameLabel.text = user.nickname
        } else {
            partnerButton.isHidden = true
            avatarImageView.web.setImage(with: nil, placeholder: UIImage(asset: .defaultAvatar))
            nickNameLabel.text = "请登陆"
        }
        favoriteAndViewedGridView.messageCount = unreadCount
        orderGridView.unreadCount = unreadCount
        tableView.reloadData()
    }
    
    @IBAction func clickPartnerButton(sender: Any) {
        guard LoginCenter.default.isLogin else {
            LoginCenter.default.forceLogin()
            return
        }
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
    
    @IBAction func clickAllOrderButton(sender: Any) {
        let controller = OrdersIndexViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        controller.initialIndex = 0
        navigationController?.pushViewController(controller, animated: true)
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
    
    @IBAction func clickMessageButton(sender: Any) {
        let controller = WebViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.title = "推送消息"
        controller.urlString = "\(v1domain)/user/push_list"
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
