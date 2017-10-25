//
//  AppDelegate+Splash.swift
//  Mall
//
//  Created by 王小涛 on 2017/8/23.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

protocol SplashViewControllerType: class {
    var skip: (() -> Void)? {get set}
    var route: ((_ routeUrl: URL) -> Void)? {get set}
}

extension AppDelegate {
    
    func showSplash<T: UIViewController>(_ splash: T) where T: SplashViewControllerType {
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.rootViewController = splash
        
        func switchToMain() {
            let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            window?.rootViewController = mainController
        }
        
        splash.skip = {
            print("skip splash")
            switchToMain()
        }
        splash.route = { routeUrl in
            print("splash route to \(routeUrl.absoluteString)")
            switchToMain()
            UIApplication.shared.open(routeUrl, options: [:], completionHandler: nil)
        }
    }
}
