//
//  UIDevice+Extension.swift
//  Library
//
//  Created by minsone on 2019/12/01.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    public class var isIPad: Bool {
        return Self.current.model.hasPrefix("iPad")
    }
}
