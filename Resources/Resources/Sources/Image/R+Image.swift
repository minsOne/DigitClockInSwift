//
//  R+Image.swift
//  Resources
//
//  Created by minsone on 2019/12/03.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

public extension R {
    enum Image {}
}
public extension R.Image {
    static var theme1: UIImage { .load(name: "theme1") }
    static var theme2: UIImage { .load(name: "theme2") }
    static var theme3: UIImage { .load(name: "theme3") }
    static var theme4: UIImage { .load(name: "theme4") }
    static var theme5: UIImage { .load(name: "theme5") }
    static var theme6: UIImage { .load(name: "theme6") }
    static var theme7: UIImage { .load(name: "theme7") }
    static var theme8: UIImage { .load(name: "theme8") }
    static var digits: UIImage { .load(name: "Digits") }
    static var rotationLock: UIImage { .load(name: "rotation_lock") }
    static var rotationUnLock: UIImage { .load(name: "rotation_unlock") }
}
