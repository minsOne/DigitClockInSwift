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

    static var theme1: UIImage { .name(#imageLiteral(resourceName: "theme1")) }
    static var theme2: UIImage { .name(#imageLiteral(resourceName: "theme2")) }
    static var theme3: UIImage { .name(#imageLiteral(resourceName: "theme3")) }
    static var theme4: UIImage { .name(#imageLiteral(resourceName: "theme4")) }
    static var theme5: UIImage { .name(#imageLiteral(resourceName: "theme5")) }
    static var theme6: UIImage { .name(#imageLiteral(resourceName: "theme6")) }
    static var theme7: UIImage { .name(#imageLiteral(resourceName: "theme7")) }
    static var theme8: UIImage { .name(#imageLiteral(resourceName: "theme8")) }
    static var digits: UIImage { .name(#imageLiteral(resourceName: "Digits")) }
    static var rotationLock: UIImage { .name(#imageLiteral(resourceName: "rotation_lock")) }
    static var rotationUnLock: UIImage { .name(#imageLiteral(resourceName: "rotation_unlock")) }
}
