//
//  HomeViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import GearNetwork
import RxSwift
import Reusable
import PullRefresh
import FoundationExtension

class HomeViewController: UITableViewController {
    
    private enum Section {
        case banners([Item])
        case headlines([Item])
        case productGroup(ProductGroup, [Item])
        
        var items: [Item] {
            
            switch self {
            case let .banners(items):
                return items
            case let .headlines(items):
                return items
            case let .productGroup(_, items):
                return items
            }
        }
    }
    
    private enum Item {
        case banner([Banner])
        case headline([Headline])
        case product(Product)
    }
    
    private var sections: [Section] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        title = "鹤採商城"
        tabBarItem.title = "首页"
        
        let tabbar = navigationController?.tabBarController?.tabBar
        tabbar?.tintColor = .white
        
        let items = tabbar?.items
        items?[0].image = UIImage(asset: .homeTab).withRenderingMode(.alwaysOriginal)
        items?[0].selectedImage = UIImage(asset: .homeTabSelected).withRenderingMode(.alwaysOriginal)
        items?[1].image = UIImage(asset: .groupTab).withRenderingMode(.alwaysOriginal)
        items?[1].selectedImage = UIImage(asset: .groupTabSelected).withRenderingMode(.alwaysOriginal)
        items?[2].image = UIImage(asset: .headlineTab).withRenderingMode(.alwaysOriginal)
        items?[2].selectedImage = UIImage(asset: .headlineTabSelected).withRenderingMode(.alwaysOriginal)
        items?[3].image = UIImage(asset: .cartTab).withRenderingMode(.alwaysOriginal)
        items?[3].selectedImage = UIImage(asset: .cartTabSelected).withRenderingMode(.alwaysOriginal)
        items?[4].image = UIImage(asset: .myTab).withRenderingMode(.alwaysOriginal)
        items?[4].selectedImage = UIImage(asset: .myTabSelected).withRenderingMode(.alwaysOriginal)
        
        tableView.estimatedRowHeight = 50
        
        tableView.register(cellType: BannersCell.self)
        tableView.register(cellType: ProductGroupHeader.self)
        
        automaticallyAdjustsScrollViewInsets = false
        
        if #available(iOS 11.0, *) {
            
        } else {
            tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        }
        
        tableView.addPullRefresh {[weak self] in
            guard let `self` = self else { return }
            self.loadData()
        }
        
        delay(time: 0.3) {
            self.loadData()
//            self.loadUser()
        }
        
        PushCountManager.shared.count.asObservable().subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (count) in
            let tabController = self?.navigationController?.tabBarController
            let tabItem = tabController?.childViewControllers[4].tabBarItem
            tabItem?.markType = .dot
            tabItem?.markValue = count == 0 ? nil : "\(count)"
        }).addDisposableTo(disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgImage = UIImage(named: "bar_bg")
        
        PushCountManager.shared.update()
        
        navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
    
    private func loadData() {
        
        DefaultDataSource(api: APIPath(path: "/home/homedata")).response(accessory: RefreshAccessory(view: tableView))
            //            .catchErrorWithComplete(handler: { [weak self] error in
            //                guard let `self` = self else {return}
            //                self.tableView.stopPullRefresh()
            //            })
            .map { (homeData: HomeData) -> [Section] in
                var sections: [Section] = []
                sections.append(Section.banners([Item.banner(homeData.banners)]))
                sections.append(Section.headlines([Item.headline(homeData.headlines)]))
                homeData.productGroups.forEach({
                    sections.append(Section.productGroup($0, $0.products.map { Item.product($0) }))
                })
                return sections
            }
            .subscribe(onNext: { [weak self] sections in
                guard let `self` = self else {return}
                self.sections = sections
                self.tableView.reloadData()
                self.tableView.stopPullRefresh()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func clickScanButton(sender: Any) {
        
        //        let url = URL(string: "hecaimall://expert")
        //        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        //        return
        
        guard LoginCenter.default.isLogin else {
            view.toast("请先登录再使用扫一扫功能")
            LoginCenter.default.forceLogin()
            return
        }
        
        LBXPermissions.authorizeCameraWith { [weak self] (granted) in
            guard let `self` = self else {return}
            guard granted else {
                LBXPermissions.jumpToSystemPrivacySetting()
                return
            }
            
            startScan()
        }
        
        func startScan() {
            DispatchQueue.main.async(execute: {
                var style = LBXScanViewStyle()
                style.centerUpOffset = 44;
                style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
                style.photoframeLineW = 2;
                style.photoframeAngleW = 18;
                style.photoframeAngleH = 18;
                style.isNeedShowRetangle = false;
                
                style.anmiationStyle = LBXScanViewAnimationStyle.LineMove;
                
                style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
                style.animationImage = UIImage(named: "scaner")
                let vc = LBXScanViewController();
                vc.scanStyle = style
                vc.scanResultDelegate = self
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    @IBAction func clickSearchButton(sender: Any) {
        
    }
}

extension HomeViewController: LBXScanViewControllerDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].items[indexPath.row] {
        case let .banner(data):
            let cell = tableView.dequeueReusableCell(for: indexPath) as BannersCell
            cell.banners = data
            return cell
        case let .headline(data):
            let cell = tableView.dequeueReusableCell(for: indexPath) as HomeHeadlineCell
            cell.headlines = data
            return cell
        case let .product(data):
            let cell = tableView.dequeueReusableCell(for: indexPath) as HomeProductCell
            cell.product = data
            cell.didClickBuy = { [weak self] product in
                self?.buyProduct(product: product)
            }
            return cell
        }
    }
    
    private func buyProduct(product: Product) {
        let view = LoadingAccessory(view: self.view)
        let parameters: [String: Any] = {
            var p: [String: Any] = [:]
            p["products[\(product.id)]"] = 1
            return p
        }()
        let api = APIPath(method: .post, path: "/user/order_previews", parameters: parameters)
        DefaultDataSource(api: api).response(accessory: view).subscribe(onNext: { [weak self] (order: Order) in
            guard let `self` = self else {return}
            let controller = OrderViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.order = order
            self.navigationController?.pushViewController(controller, animated: true)
        })
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].items[indexPath.row] {
        case .banner:
            return tableView.bounds.width / 3
        case .headline:
            return 50
        case .product:
            return 10 + (tableView.bounds.width - 30) / 16 * 7 + 30
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .banners, .headlines:
            return nil
        case let .productGroup(productGroup, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductGroupHeader.reuseIdentifier) as! ProductGroupHeader
            cell.productGroup = productGroup
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .banners, .headlines:
            return .leastNormalMagnitude
        case .productGroup:
            return tableView.bounds.width / 3
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].items[indexPath.row] {
        case let .product(data):
            let controller = ProductViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            controller.product = data
            navigationController?.pushViewController(controller, animated: true)
            
        default:
            break
        }
        
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        
        guard scanResult.strScanned != nil else { return }
        
        let onlyurl: String = {
            let url1 = scanResult.strScanned!.replacingOccurrences(of: "https://", with: "")
            return url1.replacingOccurrences(of: "http://", with: "")
        }()
        
        let onlydomain = domain.replacingOccurrences(of: "https://", with: "")
        
        guard onlyurl.hasPrefix(onlydomain) else {
            view.toast("此功能不支持扫描外部链接")
            return
        }
        
        if onlyurl.hasPrefix(onlydomain + "/qrcode/") {
            
            let productCode = onlyurl.replacingOccurrences(of: onlydomain + "/qrcode/", with: "")
            let loading = LoadingAccessory(view: view)
            DefaultDataSource(api: APIPath(path: "/product/getID/\(productCode)")).response(accessory: loading).subscribe(onNext: { [weak self] (product: Product) in
                
                
                guard let `self` = self else {return}
                
                let controller = ProductViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.product = product
                controller.qrcode = productCode
                self.navigationController?.pushViewController(controller, animated: true)
                
                let api = APIPath(method: .post, path: "/user/blood", parameters: ["qrcode": productCode])
                DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: String) in
                    let controller = UIAlertController(title: nil, message: data, preferredStyle: .alert)
                    let action = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.default, handler: nil)
                    controller.addAction(action)
                    self?.present(controller, animated: true, completion: nil)
                }).addDisposableTo(self.disposeBag)
                
            }).addDisposableTo(disposeBag)
            
         
            
        } else if onlyurl.hasPrefix(onlydomain + "/agent/") {
            
            let id = onlyurl.replacingOccurrences(of: onlydomain + "/agent/", with: "")
            let loading = LoadingAccessory(view: view)
            let api = APIPath(method: .post, path: "/user/blood", parameters: ["agent": id])
                DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: String) in
                    let controller = UIAlertController(title: nil, message: data, preferredStyle: .alert)
                    let action = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.default, handler: nil)
                    controller.addAction(action)
                    self?.present(controller, animated: true, completion: nil)
                    
                }).addDisposableTo(disposeBag)
            
        } else if onlyurl.hasPrefix(onlydomain + "/sales/") {
            
            let id = onlyurl.replacingOccurrences(of: onlydomain + "/sales/", with: "")
            let loading = LoadingAccessory(view: view)
            let api = APIPath(method: .post, path: "/user/blood", parameters: ["sales": id])
            DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: String) in
                let controller = UIAlertController(title: nil, message: data, preferredStyle: .alert)
                let action = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.default, handler: nil)
                controller.addAction(action)
                self?.present(controller, animated: true, completion: nil)
            }).addDisposableTo(disposeBag)

        } else {
            view.toast("不支持的链接，请重试")
        }
        
//        let controller = WebViewController()
//        controller.hidesBottomBarWhenPushed = true
//        controller.urlString = scanResult.strScanned
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadUser() {
        if LoginCenter.default.isLogin {
            DefaultDataSource(api: APIPath(path: "/user")).response(accessory: nil)
                .subscribe(onNext: { (data: User) in
                })
                .disposed(by: disposeBag)
        }
    }
}


