//
//  CustomServiceViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/14.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class CustomServiceViewController: UITableViewController, FromOtherStroyboard {
    
    private let disposeBag = DisposeBag()
    
    private var data: CustomService?

    override func viewDidLoad() {
        super.viewDidLoad()

        let api = APIPath(path: "/customService")
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading).subscribe(onNext: { [weak self] (data: CustomService) in
            guard let `self` = self else {return}
            self.data = data
//            self.hotlineLabel.text = "平台热线: \(data.hotline)(点击拨打)"
//            self.qqLabel.text = "客服qq: \(data.qqs.joined(separator: ","))"
//            self.wechatLabel.text = "客服微信: \(data.wechats.joined(separator: ","))"
            
            self.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if data == nil {
            return 0
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return data!.qqs.count
        } else {
            return data!.wechats.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CustomServiceCell
        if indexPath.section == 0 {
            cell.icon = UIImage(asset: .hotlinePhone)
            cell.info = "平台热线: \(data!.hotline)(点击拨打)"
        } else if indexPath.section == 1 {
            cell.icon = UIImage(asset: .qq)
            let qq = data!.qqs[indexPath.row]
            cell.info = "客服qq: \(qq)"
        }  else {
            cell.icon = UIImage(asset: .wechat)
            let wechat = data!.wechats[indexPath.row]
            cell.info = "客服微信: \(wechat)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 40
//        let text: String = {
//            guard let data = data else {return ""}
//            if indexPath.section == 0 {
//                return "平台热线: \(data.hotline)(点击拨打)"
//            } else if indexPath.section == 0 {
//                return "客服qq: \(data.qqs.joined(separator: ","))"
//            } else {
//                return "客服微信: \(data.wechats.joined(separator: ","))"
//            }
//        }()
//
//        let size = CGSize(width: tableView.bounds.width - 80, height: 999)
//        let textHeight = (text as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil).height
//        return textHeight + 30
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = data else {return}
        if indexPath.section == 0,
            let url = URL(string: data.hotline) {
            let controller = UIAlertController(title: "拨打电话", message: nil, preferredStyle: .alert)
            controller.hidesBottomBarWhenPushed = true
            controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
        }
    }
}

import Reusable

class CustomServiceCell: UITableViewCell, Reusable {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var icon: UIImage! {
        didSet {
            iconImageView.image = icon
        }
    }
    
    var info: String = "" {
        didSet {
            label.text = info
        }
    }
}
