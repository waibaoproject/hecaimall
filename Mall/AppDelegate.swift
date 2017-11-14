//
//  AppDelegate.swift
//  Mall
//
//  Created by 王小涛 on 2017/8/23.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        

        PaymentManagers.registerAccount(PaymentManagers.Account.alipay(appID: "2017110109651457"))
        PaymentManagers.registerAccount(PaymentManagers.Account.wechat(appID: "wx1bab7caad115318d", appKey: "f1d0fde5ffccfa35d7b8c14d84f60f7e"))
        
        _ = LocationManager.shared
        _ = HeathDataManager.shared
//        _ = PartnerTypesManager.shared
        
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = "5a007cc4aed179683d000026"
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx1bab7caad115318d", appSecret: "f1d0fde5ffccfa35d7b8c14d84f60f7e", redirectURL: nil)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "1106473044", appSecret: "l1hFL0yyNM99ejNU", redirectURL: nil)
        
        UINavigationBar.appearance().tintColor = .white

        UITabBar.appearance().backgroundImage = UIImage(named: "bar_bg")
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -600, vertical: 0), for: .default)
        
        return true
    }
    



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return PaymentManagers.handleOpenURL(url)
    }


}

