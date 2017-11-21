//
//  AppRouter.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/21.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import FoundationExtension

class AppRouteCenter {
    
    struct AppRoutePattern: RoutePatternConvertible {
        
        var routePattern: String {
            return [AppRoutePattern.scheme, "://", pattern.trimmingCharacters(in: CharacterSet(charactersIn: "/"))].joined()
        }
        static let scheme: String = "hecaimall"
        let pattern: String
        init(pattern: String) {
            self.pattern = pattern
        }
    }
    
    static func setupRouters() {
        
        RouteCenter.default.map(AppRoutePattern(pattern: "/orders/<id>")) { (url, parameters) -> Bool in
            guard let c = UIViewController.topMost else {return false}
            guard let id = parameters["id"] else {return false}
            jumpToOrderDetail(orderId: id, in: c)
            return true
        }
        
        RouteCenter.default.map(AppRoutePattern(pattern: "/products/<id>")) { (url, parameters) -> Bool in
            guard let c = UIViewController.topMost else {return false}
            guard let id = parameters["id"] else {return false}
            let controller = ProductViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            let product = Product(id: id)
            controller.product = product
            controller.hidesBottomBarWhenPushed = true
            c.navigationController?.pushViewController(controller, animated: true)
            return true
        }
        
        RouteCenter.default.map(AppRoutePattern(pattern: "/web")) { (url, parameters) -> Bool in
            guard let c = UIViewController.topMost else {return false}
            guard let url = parameters["url"] else {return false}
            let controller = WebViewController()
            controller.urlString = url
            controller.hidesBottomBarWhenPushed = true
            c.navigationController?.pushViewController(controller, animated: true)
            return true
        }
        
        RouteCenter.default.map(AppRoutePattern(pattern: "/expert")) { (url, parameters) -> Bool in
            guard let c = UIViewController.topMost else {return false}
            let controller = ExpertViewController.instantiate()
            controller.hidesBottomBarWhenPushed = true
            c.navigationController?.pushViewController(controller, animated: true)
            return true
        }
    }
}

