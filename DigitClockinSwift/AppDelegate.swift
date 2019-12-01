//
//  AppDelegate.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 22..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import RIBs
import UIKit
import Analytics
import MainFeature.Clock

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        _ = DCAnalytics()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let launchRouter = Clock.Builder(dependency: AppComponent()).build(colorStorageSerive: ColorStorageServiceImpl())
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        return true
    }
    
    // MARK: - Private

    private var launchRouter: LaunchRouting?
}

