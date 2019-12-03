//
//  R+Storyboard.swift
//  Resources
//
//  Created by minsone on 2019/12/03.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

extension R {
    public class Storyboard {
        let identifier: String
        let storyboard: UIStoryboard
        init(name: String, identifier: String) {
            self.identifier = identifier
            self.storyboard = UIStoryboard(name: name, bundle: R.bundle)
        }
        convenience init(name: String) {
            self.init(name: name, identifier: name)
        }
        public func viewController<T: UIViewController>() -> T {
            storyboard.instantiateViewController(withIdentifier: identifier) as! T
        }

        public static let clock = Storyboard(name: "ClockViewController")
        public static let settings = Storyboard(name: "SettingsViewController")
    }
}
