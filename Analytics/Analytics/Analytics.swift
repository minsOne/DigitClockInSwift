//
//  Analytics.swift
//  Analytics
//
//  Created by minsone on 2019/09/28.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import Firebase

public class DCAnalytics {
    public static func initialze() {
        guard
            let filePath = Bundle(for: DCAnalytics.self).path(forResource: "GoogleService-Info", ofType: "plist"),
            let fileopts = FirebaseOptions(contentsOfFile: filePath)
            else { return }

        FirebaseApp.configure(options: fileopts)
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-111",
            AnalyticsParameterItemName: "title",
            AnalyticsParameterContentType: "cont"
        ])
    }
}
