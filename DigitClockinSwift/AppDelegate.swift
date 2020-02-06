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
import MetricKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startConfigure(with: application)

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let service = ColorStorageServiceImpl()
        let launchRouter = Clock.Builder(dependency: AppComponent()).build(colorStorageSerive: service)
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        finishConfigure(with: application)
    }
    
    // MARK: - Private

    private var launchRouter: LaunchRouting?
    
    private func startConfigure(with application: UIApplication) {
        DCAnalytics.initialze()
        
        if #available(iOS 13.0, *) {
            MXMetricManager.shared.add(self)
        }
        
        application.isIdleTimerDisabled = true
    }
    
    private func finishConfigure(with application: UIApplication) {
        if #available(iOS 13.0, *) {
            MXMetricManager.shared.remove(self)
        }
    }
}

extension AppDelegate: MXMetricManagerSubscriber {
    @available(iOS 13.0, *)
    func didReceive(_ payloads: [MXMetricPayload]) {
        
    }
}

