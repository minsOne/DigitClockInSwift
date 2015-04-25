//
//  ThemeTableViewCell.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 25..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

let themeCellIdentifier = "ThemeCellId"

class ThemeTableViewCell: UITableViewCell {
  
  @IBOutlet var themeButtons: [UIButton]!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}
