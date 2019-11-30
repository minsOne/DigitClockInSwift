//
//  SettingTableViewCell.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 29..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import Foundation
import UIKit

protocol SettingTableViewCellPresenterListener: AnyObject {
    func selectedBackground(theme: UIColor)
}

class SettingTableViewCell: UITableViewCell {
    weak var delegate: SettingTableViewCellPresenterListener?
}
