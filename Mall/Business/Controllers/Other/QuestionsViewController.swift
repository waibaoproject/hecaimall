//
//  QuestionsViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import FoundationExtension
import RxSwift

class QuestionsViewController: UITableViewController, FromOtherStroyboard {
    
    private var questions: [Question] = []
    
    private var api = NextableAPIPath(path: "/user/questions")

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        
        tableView.addPullRefresh { [weak self] in
            guard let `self` = self else {return}
            self.api = self.api.first()
            self.loadData()
        }
        
        tableView.addPushRefresh { [weak self] in
            self?.loadData()
        }
        
        delay(time: 0.5) {
            self.tableView.startPullRefresh()
        }
    }
    
    private func loadData() {
        let accessory = RefreshAccessory(view: tableView)
        DefaultNextableArrayDataSource(api: api).response(accessory: accessory)
            .subscribe(onNext: { [weak self] (data: [Question]) in
                guard let `self` = self else {return}
                if self.api.isFirst {
                    self.questions = data
                } else {
                    self.questions += data
                }
                self.tableView.reloadData()
                self.api = self.api.next()
            })
        .disposed(by: disposeBag)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as QuestionCell
        cell.question = questions[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuestionCell.cellHeight(tableView: tableView, question: questions[indexPath.section])
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
