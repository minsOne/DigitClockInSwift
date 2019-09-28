//
//  UIColorExtension.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 29..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  static func rgba(r: Int, g: Int, b: Int, a: Float) -> UIColor {
    let floatRed = CGFloat(r) / 255.0
    let floatGreen = CGFloat(g) / 255.0
    let floatBlue = CGFloat(b) / 255.0
    return UIColor(red: floatRed, green: floatGreen, blue: floatBlue, alpha: CGFloat(a))
  }
}
