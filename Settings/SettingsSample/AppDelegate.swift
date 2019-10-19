//
//  AppDelegate.swift
//  SettingsSample
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import UIKit
import Settings

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = Settings.ViewController.instance
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

