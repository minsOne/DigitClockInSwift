//
//  ColorStorageService.swift
//  DigitClockinSwift
//
//  Created by minsone on 2019/12/01.
//  Copyright © 2019 minsOne. All rights reserved.
//

import Foundation
import UIKit
import protocol Clock.ColorStorageService

struct ColorStorageServiceImpl: ColorStorageService {
    let initBackgroundColor: UIColor?
    
    init() {
        initBackgroundColor = ThemeColor.initialThemeColor().nowTheme
            ?? ThemeColor.colorList.first
    }
    
    func store(color: UIColor) {
        ThemeColor.sharedInstance.nowTheme = color
        ThemeColor.storeThemeColor(theme: ThemeColor.sharedInstance)
    }
}
