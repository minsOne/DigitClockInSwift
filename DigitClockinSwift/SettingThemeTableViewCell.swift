//
//  ThemeTableViewCell.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 25..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

let themeCellIdentifier = "ThemeCellId"

final class SettingThemeTableViewCell: SettingTableViewCell {
    
    // MARK: Properties
    @IBOutlet var themeButtons: [UIButton]!
    
    var themeList: [UIColor] = []
}

// MARK: View Life Cycle
extension SettingThemeTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        initThemeList()
        adjustThemeInButton()
        adjustTouchInButton()
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
        for (index, button) in themeButtons.enumerated() {
            button.backgroundColor = themeList[index]
            button.tag = index
        }
    }
    
    func adjustTouchInButton() {
        guard responds(to: #selector(SettingThemeTableViewCell.pressedThemeButton))
            else { return }
        themeButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(SettingThemeTableViewCell.pressedThemeButton),
                for: .touchUpInside)
        }
    }
    
    @objc func pressedThemeButton(button: UIButton) {
        guard let delegate = delegate,
            let theme = UIColor?(themeList[button.tag]) else { return }
        delegate.selectedBackground(theme: theme)
    }
}
