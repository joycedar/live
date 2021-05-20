//
//  AppDelegate.swift
//
//  Created by liwei on 2016/12/19.
//  Copyright © 2016年 live. All rights reserved.
//

import UIKit
import HyphenateChat


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let homeTabViewController = HomeTabBarViewController()
        self.window?.rootViewController = homeTabViewController
        self.window?.makeKeyAndVisible()
        

        //登陆环信
        let options = EMOptions(appkey: "1137210426091189#demo")
        EMClient.shared()?.initializeSDK(with: options)
        DispatchQueue.main.async {
            EMClient.shared()?.login(withUsername: "happy2", password: "123", completion: { (success, error) in
                if error == nil {
                    print("😊登陆成功")
                    EMClient.shared()?.chatManager.add(homeTabViewController, delegateQueue: nil)
                } else {
                    print("😢登陆失败")
                }
            })
        }
        
        let userInfo = EMUserInfo()
        userInfo.nickName = "happy2"
        EMClient.shared()?.userInfoManager.updateOwn(userInfo, completion: { (newUserInfo, error) in
            if newUserInfo != nil {
                print("😊注册成功")
                
            } else {
                print("😢登入失败")
            }
        })
        
        UIButton.appearance().isExclusiveTouch = true
        //注册
        SWHelper.shared
            
        return true
    }



    // MARK: UISceneSession Lifecycle

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    


}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


