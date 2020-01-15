//
//  R+Image.swift
//  Resources
//
//  Created by minsone on 2019/12/03.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

extension R {
    public struct Image: _ExpressibleByImageLiteral {
        let image: UIImage

        public init(imageLiteralResourceName path: String) {
            if let image = UIImage(named: path, in: R.bundle, compatibleWith: nil) {
                self.image = image
            } else {
                assert(false, "해당 이미지가 없습니다.")
                self.image = UIImage()
            }
        }

        public static func name(_ image: Image) -> UIImage {
            return image.image
        }
    }
}

public extension R.Image {
    static var theme1: UIImage { Self.name(#imageLiteral(resourceName: "theme1")) }
    static var theme2: UIImage { Self.name(#imageLiteral(resourceName: "theme2")) }
    static var theme3: UIImage { Self.name(#imageLiteral(resourceName: "theme3")) }
    static var theme4: UIImage { Self.name(#imageLiteral(resourceName: "theme4")) }
    static var theme5: UIImage { Self.name(#imageLiteral(resourceName: "theme5")) }
    static var theme6: UIImage { Self.name(#imageLiteral(resourceName: "theme6")) }
    static var theme7: UIImage { Self.name(#imageLiteral(resourceName: "theme7")) }
    static var theme8: UIImage { Self.name(#imageLiteral(resourceName: "theme8")) }
    static var digits: UIImage { Self.name(#imageLiteral(resourceName: "Digits")) }
    static var rotationLock: UIImage { Self.name(#imageLiteral(resourceName: "rotation_lock")) }
    static var rotationUnLock: UIImage { Self.name(#imageLiteral(resourceName: "rotation_unlock")) }
}

/*
 extension UIImage {
     static func image(_ rImage: R.Image) -> UIImage {
         return rImage.image
     }
 }

 public extension R.Image {
     static var theme1: UIImage { .image(#imageLiteral(resourceName: "theme1")) }
     static var theme2: UIImage { .image(#imageLiteral(resourceName: "theme2")) }
     static var theme3: UIImage { .image(#imageLiteral(resourceName: "theme3")) }
     static var theme4: UIImage { .image(#imageLiteral(resourceName: "theme4")) }
     static var theme5: UIImage { .image(#imageLiteral(resourceName: "theme5")) }
     static var theme6: UIImage { .image(#imageLiteral(resourceName: "theme6")) }
     static var theme7: UIImage { .image(#imageLiteral(resourceName: "theme7")) }
     static var theme8: UIImage { .image(#imageLiteral(resourceName: "theme8")) }
     static var digits: UIImage { .image(#imageLiteral(resourceName: "Digits")) }
     static var rotationLock: UIImage { .image(#imageLiteral(resourceName: "rotation_lock")) }
     static var rotationUnLock: UIImage { .image(#imageLiteral(resourceName: "rotation_unlock")) }
 }

 */
