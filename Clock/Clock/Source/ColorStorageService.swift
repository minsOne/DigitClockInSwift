//
//  ColorStorageService.swift
//  Clock
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import UIKit

public protocol ColorStorageService {
    var initBackgroundColor: UIColor? { get }
    func store(color: UIColor)
}
