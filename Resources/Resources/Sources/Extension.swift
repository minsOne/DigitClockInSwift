//
//  Extension.swift
//  Resources
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

private class CurrentBundle {}

extension Bundle {
    static var current: Bundle {
        return Bundle(for: CurrentBundle.self)
    }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        if let image = UIImage(named: name, in: Bundle.current, compatibleWith: nil) {
            return image
        } else {
            assert(false, "이미지 로드 실패")
            return UIImage()
        }
    }
}
