//
//  ReqeustAccessory.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/2.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

protocol RequestAccessory {
    func requestWillStart()
    func requestDidStop()
}

struct LoadingAccessory: RequestAccessory {
    
    private let view: UIView
    private let message: String?
    
    init(view: UIView, message: String? = nil) {
        self.view = view
        self.message = message
    }
    
    func requestWillStart() {
        view.makeToastActivity(.center)
    }
    
    func requestDidStop() {
        view.hideToastActivity()
        (view as? UIScrollView)?.stopPullRefresh()
        (view as? UIScrollView)?.stopPushRefresh()
    }
}

struct RefreshAccessory: RequestAccessory {
    private let view: UIScrollView
    
    init(view: UIScrollView) {
        self.view = view
    }
    
    func requestWillStart() {
        
    }
    
    func requestDidStop() {
        view.hideToastActivity()
        view.stopPushRefresh()
        view.stopPullRefresh()
    }
}

