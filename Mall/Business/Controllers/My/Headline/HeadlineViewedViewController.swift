//
//  HeadlineViewedViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/5.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import FoundationExtension
import RxSwift

class HeadlineViewedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FromProductStoryboard {
    
    private var sections: [(String, [Headline])] = []
    
    private var selectedIds: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBar: UIView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    private var isEditMode: Bool = false
    
    private var api = NextableAPIPath(path: "/user/footPrintHeadlinesList")
    private var headlines: [Headline] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "资讯足迹"
        
        tableView.register(cellType: HeadlineViewedCell.self)
        tableView.register(cellType: DateHeaderView.self)
        
        reloadData()
        
        tableView.addPullRefresh { [weak self] in
            guard let `self` = self else {return}
            self.api = self.api.first()
            self.load()
        }
        
        tableView.addPushRefresh { [weak self] in
            guard let `self` = self else {return}
            self.load()
        }
        
        delay(time: 0.5) {
            self.tableView.startPullRefresh()
        }
    }
    
    func reloadData() {
        deleteBar.isHidden = !isEditMode
        selectedLabel.text = "已选择\(selectedIds.count)个商品"
        tableView.contentInset = UIEdgeInsetsMake(0, 0, isEditMode ? 40: 0, 0)
        tableView.reloadData()
    }
    
    @IBAction func clickEditButton(sender: UIButton) {
        isEditMode = !isEditMode
        sender.isSelected = isEditMode
        reloadData()
    }
    
    
    
    @IBAction func clickDelete(sender: UIButton) {
        guard selectedIds.count > 0 else {return}
        let loading = LoadingAccessory(view: view)
        let ids = selectedIds.joined(separator: ",")
        responseVoid(accessory: loading, urlRequest: APIPath(method: .delete, path: "/user/footPrintHeadlines/id/\(ids)"))
            .subscribe(onNext: {[weak self]  () in
                guard let `self` = self else {return}
                
                let headlines = self.headlines.filter({
                    !self.selectedIds.contains($0.id)
                })
                self.selectedIds.removeAll()
                self.generateSections(headlines: headlines)
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func generateSections(headlines: [Headline]) {
        var today: [Headline] = []
        var yestoday: [Headline] = []
        var early: [Headline] = []
        headlines.forEach {
            if $0.footDate.isToday {
                today.append($0)
            } else if $0.footDate.isYesterday {
                yestoday.append($0)
            } else {
                early.append($0)
            }
        }
        self.sections.removeAll()
        self.sections.append(("今天", today))
        self.sections.append(("昨天", yestoday))
        self.sections.append(("更早", early))
        self.sections = self.sections.filter({ $0.1.count > 0 })
    }
    
    private func load() {
        
        let accessory = RefreshAccessory(view: tableView)
        DefaultNextableArrayDataSource(api: api).response(accessory: accessory)
            .subscribe(onNext: {[weak self] (data: [Headline]) in
                guard let `self` = self else {return}
                
                if self.api.isFirst {
                    self.headlines = data
                } else {
                    self.headlines += data
                }
                self.generateSections(headlines: self.headlines)
                self.reloadData()
                self.api = self.api.next()
                
            }).disposed(by: disposeBag)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as HeadlineViewedCell
        let headline = sections[indexPath.section].1[indexPath.row]
        cell.headline = headline
        cell.isEditMode = isEditMode
        cell.is_selected = selectedIds.contains(headline.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: DateHeaderView.reuseIdentifier) as! DateHeaderView
        view.dateLabel.text = sections[section].0
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let headline = sections[indexPath.section].1[indexPath.row]
        if isEditMode {
            let isSelected = selectedIds.contains(headline.id)
            if isSelected {
                selectedIds.remove(headline.id)
            } else {
                selectedIds.append(headline.id)
            }
            reloadData()
        } else {
            let controller = HeadlineViewController()
            controller.id = headline.id
            controller.hidesBottomBarWhenPushed = true
            controller.url = headline.link
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}


