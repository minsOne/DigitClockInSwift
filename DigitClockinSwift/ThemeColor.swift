//
//  ThemeColor.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 5. 1..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import Foundation
import UIKit

class ThemeColor: NSObject, NSCoding {
    var nowTheme: UIColor?
    static let sharedInstance = ThemeColor()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.nowTheme = coder.decodeObject(forKey: "nowTheme") as? UIColor
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.nowTheme, forKey: "nowTheme")
    }

    class func initialThemeColor() -> ThemeColor {
        let unArchivedData: AnyObject? = UserDefaults.standard.object(forKey: "themeColor") as AnyObject?
        
        if let data: AnyObject = unArchivedData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ThemeColor
        }
        return ThemeColor.sharedInstance
    }
    
    class func storeThemeColor(theme: ThemeColor) {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: theme)
        
        UserDefaults.standard.set(archivedData, forKey: "themeColor")
        UserDefaults.standard.synchronize()
    }
    
    static var colorList: [UIColor] {
        [UIColor(red:1, green:0.19, blue:0.12, alpha:1),
         UIColor(red:0, green:0.5, blue:0.96, alpha:1),
         UIColor(red:0.07, green:0.07, blue:0.07, alpha:1),
         UIColor(red:1, green:0.58, blue:0, alpha:1),
         UIColor(red:0.68, green:0, blue:0.8, alpha:1),
         UIColor(red:0.4, green:0.4, blue:0.4, alpha:1),
         UIColor.rgba(r: 247, g: 202, b: 201, a: 1),
         UIColor.rgba(r: 145, g: 168, b: 209, a: 1)]
    }
}
