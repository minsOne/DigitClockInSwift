//
//  Extension.swift
//  Resources
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    private class FakeBundle {}
    
    static var frameworkBundle: Bundle {
        return Bundle(for: FakeBundle.self)
    }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        if let image = UIImage(named: name, in: Bundle.frameworkBundle, compatibleWith: nil) {
            return image
        } else {
            assert(false, "이미지 로드 실패")
            return UIImage()
        }
    }
}
