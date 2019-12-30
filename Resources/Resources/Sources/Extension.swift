//
//  Extension.swift
//  Resources
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func load(name: String) -> UIImage {
        if let image = UIImage(named: name, in: R.bundle, compatibleWith: nil) {
            return image
        } else {
            assert(false, "이미지 로드 실패")
            return UIImage()
        }
    }
    struct WrappedBundleImage: _ExpressibleByImageLiteral {
        let image: UIImage?
        let name: String

        init(imageLiteralResourceName name: String) {
            self.name = name
            self.image = UIImage(named: name, in: R.bundle, compatibleWith: nil)
        }
    }
    static func name(_ wrappedImage: WrappedBundleImage) -> UIImage {
        return wrappedImage.image!
    }
}
