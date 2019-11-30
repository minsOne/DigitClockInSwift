//
//  ViewController.swift
//  Settings
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import RIBs
import RxSwift
import UIKit
import Library

public protocol PresentableListener: class {
    func update(color: UIColor)
}

final public class ViewController: UITableViewController, SettingTableViewCellPresenterListener, Instantiable, Presentable, ViewControllable {
    public static var storyboardName: String { "SettingsViewController" }
    
    
    // MARK: Properties
    var btnDone: UIBarButtonItem?
    private let headerTitleList = ["Theme", "Maker", "Version"]
    private let makerTexts = ["Developer : Ahn Jung Min",
                              "Designer : Joo Sung Hyun"]

    public weak var listener: PresentableListener?
    
    override public var prefersStatusBarHidden: Bool { true }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.title = "Digit Clock"
        self.initBarButton()
    }
    
    func initBarButton() {
        guard responds(to: #selector(pressedDoneBtn))
            else { return }

        btnDone = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(pressedDoneBtn))
        
        navigationItem.setRightBarButton(btnDone, animated: true)
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int { 3 }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return makerTexts.count
        default: return 1
        }
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell
        
        switch indexPath.section {
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: makerCellIdentifier,
                                                 for: indexPath)
                as! SettingMakerTableViewCell
            let makerCell = cell as! SettingMakerTableViewCell
            
            makerCell.makerLabel.text = makerTexts[indexPath.row]
        case 2:
            cell = tableView.dequeueReusableCell(
                withIdentifier: versionCellIdentifier,
                for: indexPath)
                as! SettingVersionTableViewCell
            
            let versionCell = cell as! SettingVersionTableViewCell
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            
            versionCell.versionLabel.text = "Version : " + version
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: themeCellIdentifier, for: indexPath)
            as! SettingThemeTableViewCell
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headerTitleList[section]
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @objc func pressedDoneBtn(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectedBackground(theme: UIColor) {
        listener?.update(color: theme)

        if !UIDevice.current.model.hasPrefix("iPad") {
            dismiss(animated: true, completion: nil)
        }
    }
}
