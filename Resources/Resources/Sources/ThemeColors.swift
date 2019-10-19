//
//  ThemeColors.swift
//  Resources
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit
import Library

public enum ThemeColor: CaseIterable {
    case C1, C2, C3, C4, C5, C6, C7, C8
    
    public var color: UIColor {
        switch self {
        case .C1: return UIColor(red:1, green:0.19, blue:0.12, alpha:1)
        case .C2: return UIColor(red:0, green:0.5, blue:0.96, alpha:1)
        case .C3: return UIColor(red:0.07, green:0.07, blue:0.07, alpha:1)
        case .C4: return UIColor(red:1, green:0.58, blue:0, alpha:1)
        case .C5: return UIColor(red:0.68, green:0, blue:0.8, alpha:1)
        case .C6: return UIColor(red:0.4, green:0.4, blue:0.4, alpha:1)
        case .C7: return UIColor.rgba(r: 247, g: 202, b: 201, a: 1)
        case .C8: return UIColor.rgba(r: 145, g: 168, b: 209, a: 1)
        }
    }
}
