//
//  AppDelegate.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 22..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit
import Analytics
import MainFeature.Clock

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        _ = DCAnalytics()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = Clock.ViewController.instance
        vc.colorStorageService = ColorStorageServiceImpl()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

private struct ColorStorageServiceImpl: Clock.ColorStorageService {
    let initBackgroundColor: UIColor?
    
    init() {
        initBackgroundColor = ThemeColor.initialThemeColor().nowTheme
            ?? ThemeColor.colorList.first
    }
    
    func store(color: UIColor) {
        ThemeColor.sharedInstance.nowTheme = color
        ThemeColor.storeThemeColor(theme: ThemeColor.sharedInstance)
    }
}
