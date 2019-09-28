//
//  SettingTableViewController.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 25..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

let kSectionCount = 3
let kMakerSectionIndex = 1
let kMakerSectionRow = 2, kDefaultRow = 1

class SettingTableViewController: UITableViewController {
    
    // MARK: Properties
    var btnDone: UIBarButtonItem?
    var headerTitleList: [String] = []
    weak var delegate: DigitClockViewController?
}

// MARK: View Life Cycle
extension SettingTableViewController {
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override var prefersStatusBarHidden: Bool { true }
}

// MARK: Initialize
extension SettingTableViewController {
    func setup() {
        self.title = "Digit Clock"
        self.headerTitleList = getHeaderTitleList()
        self.initBarButton()
    }
    
    func initBarButton() {
        guard responds(to: #selector(SettingTableViewController.pressedDoneBtn))
            else { return }

        btnDone = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(SettingTableViewController.pressedDoneBtn))
        
        navigationItem.setRightBarButton(btnDone, animated: true)
    }
}

// MARK: UITableViewDataSource
extension SettingTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return kSectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == kMakerSectionIndex ? kMakerSectionRow : kDefaultRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell
        
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: makerCellIdentifier,
                                                 for: indexPath)
                as! SettingMakerTableViewCell
            let makerCell = cell as! SettingMakerTableViewCell
            
            makerCell.makerLabel.text = self.getMakerText(index: indexPath.row)
            
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(
                withIdentifier: versionCellIdentifier,
                for: indexPath)
                as! SettingVersionTableViewCell
            
            let versionCell = cell as! SettingVersionTableViewCell
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            
            versionCell.versionLabel.text = "Version : " + version
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: themeCellIdentifier, for: indexPath)
                as! SettingThemeTableViewCell
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String?(self.headerTitleList[section]) ?? "Title"
    }
}

// MARK: UITableViewDelegate
extension SettingTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


// MARK: Touch/Gesture Handling
extension SettingTableViewController {
    @objc func pressedDoneBtn(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectedBackground(theme: UIColor) {
        delegate?.updateBackground(theme: theme)
        if !UIDevice.current.model.hasPrefix("iPad") {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: Util Methods
extension SettingTableViewController {
    func getMakerText(index: Int) -> String {
        switch( index ) {
        case 0:
            return "Developer : Ahn Jung Min"
        case 1:
            return "Designer : Joo Sung Hyun"
        default:
            return "None"
        }
    }
    
    func getHeaderTitleList() -> [String] {
        var lists = [String]()
        lists += ["Theme"]
        lists += ["Maker"]
        lists += ["Version"]
        return lists
    }
}

// MARK: Memory Handling
extension SettingTableViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
