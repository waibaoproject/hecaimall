//
//  PushCountManager.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/29.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import RxSwift

class PushCountManager {
    static let shared = PushCountManager()
    private init() {}
    
    var count: Variable<Int> = Variable(0)
    var agentCount: Variable<Int> = Variable(0)
    
    private let disposeBag = DisposeBag()
    
    func update() {
        if LoginCenter.default.isLogin {
            DefaultDataSource(api: APIPath(path: "/user/push_count")).response(accessory: nil).subscribe(onNext: { (push: PushCount) in
                self.count.value = push.count
            }).addDisposableTo(disposeBag)
            
        } else {
            count.value = 0
        }
    }
    
    func updateAgent() {
        if LoginCenter.default.isLogin {
            DefaultDataSource(api: APIPath(path: "/user/agentpush_count")).response(accessory: nil).subscribe(onNext: { (push: PushCount) in
                self.agentCount.value = push.count
            }).addDisposableTo(disposeBag)
            
        } else {
            agentCount.value = 0
        }
    }
}
