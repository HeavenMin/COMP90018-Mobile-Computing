//
//  AppDelegate.swift
//  KeepFit
//
//  Created by Min Gao on 2017/8/29.
//  Copyright © 2017年 Min Gao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Azure client
    var client: MSClient?
    var isLogin:Bool
    var userName:String?
    override init() {
        self.isLogin = false
        self.userName = nil
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //init Azure, create the client
        self.client = MSClient(
            applicationURLString:"https://keepfitcloud.azurewebsites.net"
        )
        
        //test for Azure********** do not use if you are not test for azure
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let client = delegate.client!
//        let item = ["text":"test2"]
//        let itemTable = client.table(withName: "TodoItem")
//        itemTable.insert(item) { (result, error) in
//            if let err = error {
//                print("ERROR ", err)
//            } else if let item = result {
//                print("Todo Item: ", item["text"]!)
//            }
//        }
        //*************************
        
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


}

