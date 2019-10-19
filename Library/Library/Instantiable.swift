//
//  Instantiable.swift
//  Library
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

public protocol Instantiable: class {
    static var storyboardName: String { get }
}

extension Instantiable {
    public static var instance: Self { instantiateFromStoryboardHelper() }
    
    private static func instantiateFromStoryboardHelper<T: AnyObject>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: T.self))
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
