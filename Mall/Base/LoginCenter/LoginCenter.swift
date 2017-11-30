//
//  LoginCenter.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/19.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import RxSwift

class LoginCenter {
    
    static let `default` = LoginCenter()
    
    private let disposeBag = DisposeBag()
    
    private let accessTokenKey = "com.hecaishangcheng.access_token"
    
    private init() {
        let token = UserDefaults.standard.string(forKey: accessTokenKey)
        accessToken = token
    }
    
    var isLogin: Bool {
        return accessToken != nil
    }
    
    private(set) var accessToken: String? = nil {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: self.accessTokenKey)
        }
    }
    
    func loginIfNeeded() -> Observable<String> {
        
        if let accessToken = accessToken {
            return Observable.just(accessToken)
        } else {
            return Observable.create({ (observer) -> Disposable in
                let controller = LoginViewController.instantiate()
                controller.hidesBottomBarWhenPushed = true
                controller.didLogin = { [weak self, weak controller] in
                    self?.accessToken = $0
                    observer.onNext($0)
                    observer.onCompleted()
                    controller?.navigationController?.popViewController(animated: true)
                }
                UIViewController.topMost?.navigationController?.pushViewController(controller, animated: true)
                return Disposables.create()
            })
        }
    }
    
    func logout() {
        accessToken = nil
        responseVoid(accessory: nil, urlRequest: APIPath(method: .post, path: "/login/loginout")).subscribe(onNext: {
        }).addDisposableTo(disposeBag)
    }
    
    func forceLogin()  {
        
        guard !(UIViewController.topMost is LoginViewController) else {
            return
        }
            
        accessToken = nil
  
        let controller = LoginViewController.instantiate()
        controller.hidesBottomBarWhenPushed = true
        controller.didLogin = { [weak self, weak controller] in
            self?.accessToken = $0
            controller?.navigationController?.popViewController(animated: true)
        }
        UIViewController.topMost?.navigationController?.pushViewController(controller, animated: true)
    }
}
