//
//  AddressManagerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/7.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift

class AddressManagerViewController: UIViewController, FromOrderStoryboard {
    
    @IBOutlet weak var tableView: UITableView!

    private var receivers: [Receiver] = []
    
    private let disposeBag = DisposeBag()
    
    var didSelectReceiver: ((Receiver) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIPath(path: "/user/receivers")
        let accessory = LoadingAccessory(view: view)
        DefaultArrayDataSource(api: api).response(accessory: accessory).subscribe(onNext: { [weak self] (receivers: [Receiver]) in
            guard let `self` = self else {return}
            self.receivers = receivers
            self.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    


    
    @IBAction func clickAddAddressButton(sender: Any) {
        view.endEditing(true)
        let controller = AddressEditViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        controller.didSave = {
            self.receivers.insert($0, at: 0)
            self.tableView.reloadData()
            self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AddressManagerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return receivers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as AddressManagerCell
        cell.receiver = receivers[indexPath.section]
        
        cell.didClickSelectReceiverButton = { [weak self] _ in
            guard let `self` = self else { return }
            var receiver = self.receivers[indexPath.section]
            receiver.isDefault = !receiver.isDefault
            self.modifyReceiver(receiver, at: indexPath)
        }
        
        cell.didClickDeleteReceiverButton = { [weak self] _ in
            guard let `self` = self else { return }
            let id = self.receivers[indexPath.section].id
            let api = APIPath(method: .delete, path: "/user/receivers/id/\(id)")
            let accessory = LoadingAccessory(view: self.view)
            responseVoid(accessory: accessory, urlRequest: api)
                .subscribe(onNext: { [weak self] in
                    guard let `self` = self else { return }
                    self.receivers.remove(at: indexPath.section)
                    self.tableView.reloadData()
                })
            .disposed(by: self.disposeBag)
        }
        cell.didClickEditReceiverButton = { [weak self] _ in
            guard let `self` = self else { return }
            let controller = AddressEditViewController.instantiate()
            controller.receiver = self.receivers[indexPath.section]
            controller.hidesBottomBarWhenPushed = true
            controller.didSave = {
                self.receivers[indexPath.section] = $0
                self.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectReceiver?(receivers[indexPath.section])
    }
    
    func modifyReceiver(_ receiver: Receiver, at indexPath: IndexPath) {
        
        let parameters: [String: Any] = ["name": receiver.name,
                                         "phone": receiver.phone,
                                         "district_code": receiver.districtCode,
                                         "detail": receiver.detail,
                                         "is_default": receiver.isDefault]
        
        let api = APIPath(method: .put, path: "/user/receivers/id/\(receiver.id)", parameters: parameters)
        let accessory = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: accessory).subscribe(onNext: { [weak self] (receiver: Receiver) in
            guard let `self` = self else {return}
            self.receivers[indexPath.section] = receiver
            self.receivers = self.receivers.enumerated().map({
                var r = $0.element
                r.isDefault = (indexPath.section == $0.offset)
                return r
            })
            
            self.tableView.reloadData()
        })
            .disposed(by: disposeBag)
    }
}

