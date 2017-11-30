//
//  AppDelegate.swift
//  Mall
//
//  Created by 王小涛 on 2017/8/23.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import WebImage
import UserNotifications
import UserNotificationsUI
import RxSwift


//let v1domain = "http://gc.ucardpro.com/v1"
let v1domain = "https://gc.hotchoose.com/v1"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        registerAppNotificationSettings(launchOptions: launchOptions)

        PaymentManagers.registerAccount(PaymentManagers.Account.alipay(appID: "2017110109651457"))
        PaymentManagers.registerAccount(PaymentManagers.Account.wechat(appID: "wx1bab7caad115318d", appKey: "f1d0fde5ffccfa35d7b8c14d84f60f7e"))
        
        _ = LocationManager.shared
        _ = HeathDataManager.shared
//        _ = PartnerTypesManager.shared
        
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = "5a007cc4aed179683d000026"
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "3120393848", appSecret: "d8ef7767de233a6312edb000d9c32fe2", redirectURL: nil)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx1bab7caad115318d", appSecret: "f1d0fde5ffccfa35d7b8c14d84f60f7e", redirectURL: "https://sns.whalecloud.com/sina2/callback")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "101440808", appSecret: "l1hFL0yyNM99ejNU", redirectURL: nil)
        
        UINavigationBar.appearance().tintColor = .white

        UITabBar.appearance().backgroundImage = UIImage(named: "bar_bg")
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -600, vertical: 0), for: .default)
        
        AppRouteCenter.setupRouters()
        
        PushCountManager.shared.update()
        
        
        
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
        return PaymentManagers.handleOpenURL(url) || RouteCenter.default.route(url: url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let nsdata = NSData(data: deviceToken)
        let token = nsdata.description
            /*.replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: " ", with: "")*/
        print("device token = \(token)")
        let api = APIPath(method: .post, path: "/push/config/iOS", parameters: ["device_token": token])
        responseVoid(accessory: nil, urlRequest: api).subscribe(onNext: {
            print("上报device token成功")
        }).addDisposableTo(disposeBag)
    }

    private func registerAppNotificationSettings(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    print("iOS request notification success")
                }else{
                    print(" iOS 10 request notification fail")
                }
            }
        } else { //iOS8,iOS9注册通知
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        print("收到新消息Active\(userInfo)")
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let urlString = userInfo["route"] as? String,
            let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        completionHandler([.sound,.alert])
        
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        let userInfo = response.notification.request.content.userInfo
        print("收到新消息Active\(userInfo)")
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let urlString = userInfo["route"] as? String,
            let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("收到新消息Active\(userInfo)")
            UIApplication.shared.applicationIconBadgeNumber = 0
            if let urlString = userInfo["route"] as? String,
                let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            completionHandler(.newData)
    }
}

