//
//  AppDelegate.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 22..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit
import Analytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func applicationDidFinishLaunching(_ application: UIApplication) {
        application.isIdleTimerDisabled = true
        _ = DCAnalytics()
    }
}

