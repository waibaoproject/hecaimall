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

        // TODO
        PaymentManagers.registerAccount(PaymentManagers.Account.alipay(appID: "???"))
        PaymentManagers.registerAccount(PaymentManagers.Account.wechat(appID: "wxd5303f3621dd900d", appKey: "wechatpay"))
        
        _ = LocationManager.shared
        _ = HeathDataManager.shared
        _ = PartnerTypesManager.shared
        
        UINavigationController.swizzle()
        
        
        let bgImage = UIImage(named: "bar_bg")
        UINavigationBar.appearance().setBackgroundImage(bgImage, for: .default)
        UINavigationBar.appearance().tintColor = .white
        
        UITabBar.appearance().backgroundImage = bgImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -600, vertical: 0), for: .default)
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

//        let key = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503397296336&di=8febd8f2960b049cbbe81cc09dee8b0a&imgtype=0&src=http%3A%2F%2Fimg1.sc115.com%2Fuploads%2Fsc%2Fjpg%2F144%2F18479.jpg"
//        DefaultImageDownloader.shared.donwloadImage(with: URL(string: key)!)
//
//        let splashController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateInitialViewController() as! SplashScreenViewController
////        splashController.image = UIImage(named: "launch_new")
//        let splash = SplashScreenViewController.Splash(image: { () -> UIImage? in
//            return DefaultImageCache.shared.retrieveImage(forKey: key)
//        }, route: "http://www.baidu.com")
//        splashController.splash = splash
//        showSplash(splashController)
//        window = UIWindow(frame: UIScreen.main.bounds)
//        
//        let mainWindow = window!
//        let splashController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateInitialViewController()!
//        mainWindow.rootViewController = splashController
//        let mainController = UIStoryboard(name:"Main", bundle: nil).instantiateInitialViewController()!
//        
//        
//        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(Int(duration)))
//        
//        timer.setEventHandler(handler: {
//            print("广告倒计时")
//            if self.duration == 0 {
//                DispatchQueue.main.sync(execute: { 
//                    mainWindow.rootViewController = mainController
//                })
//                
//                self.timer.cancel()
//            }
//            self.duration -= 1
//        
//        })
//        timer.resume()
//        
//
//        
//        mainWindow.makeKeyAndVisible()
        
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
        return true
    }


}

