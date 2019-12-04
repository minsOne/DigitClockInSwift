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
        public let storyboard: UIStoryboard
        public init(name: String, identifier: String) {
            self.identifier = identifier
            self.storyboard = UIStoryboard(name: name, bundle: R.bundle)
        }
        public convenience init(name: String) {
            self.init(name: name, identifier: name)
        }
        public func instance<T: UIViewController>() -> T {
            storyboard.instantiateViewController(withIdentifier: identifier) as! T
        }
    }
}

extension R.Storyboard {
    public typealias Storyboard = R.Storyboard

    public static var clock: Storyboard { Storyboard(name: "ClockViewController") }
    public static var settings: Storyboard { Storyboard(name: "SettingsViewController") }
}
