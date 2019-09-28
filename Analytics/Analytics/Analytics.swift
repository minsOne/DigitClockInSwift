//
//  Analytics.swift
//  Analytics
//
//  Created by minsone on 2019/09/28.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import FirebaseCore

public class Analytics {
    public init() {
        if let filePath = Bundle.frameworkBundle.path(forResource: "GoogleService-Info", ofType: "plist") {
            if let fileopts = FirebaseOptions(contentsOfFile: filePath) {
                FirebaseApp.configure(options: fileopts)
            }
        }
    }
}

class FakeBundle {}
extension Bundle {
    private class FakeBundle {}
    
    static var frameworkBundle: Bundle {
        return Bundle(for: FakeBundle.self)
    }
}
