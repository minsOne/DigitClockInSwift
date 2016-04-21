//
//  ThemeTableViewCell.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 25..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

let themeCellIdentifier = "ThemeCellId"

class SettingThemeTableViewCell: SettingTableViewCell {
  
  // MARK: Properties
  @IBOutlet var themeButtons: [UIButton]!
  
  var themeList: [UIColor] = []
}

// MARK: View Life Cycle
extension SettingThemeTableViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
    self.initThemeList()
    self.adjustThemeInButton()
    self.adjustTouchInButton()
  }
}

// MARK: Initialize
extension SettingThemeTableViewCell {
  func initThemeList() {
    themeList = ThemeColor.getThemeColorList()
    themeButtons.forEach { $0.layer.cornerRadius = $0.frame.size.height / 5 }
  }
}

// MARK: View Handling
extension SettingThemeTableViewCell {
  func adjustThemeInButton() {
    for (index, button) in themeButtons.enumerate() {
      button.backgroundColor = themeList[index]
      button.tag = index
    }
  }

  func adjustTouchInButton() {
    if self.respondsToSelector(#selector(SettingThemeTableViewCell.pressedThemeButton(_:))) {
      themeButtons.forEach {
        $0.addTarget(
          self,
          action: #selector(SettingThemeTableViewCell.pressedThemeButton(_:)),
          forControlEvents: UIControlEvents.TouchUpInside)
      }
    }
  }

  func pressedThemeButton(button: UIButton) {
    if let delegate = delegate, theme = UIColor?(themeList[button.tag])
      where delegate.respondsToSelector(#selector(delegate.selectedBackground(_:))) {
        delegate.selectedBackground(theme)
    }
  }
}
