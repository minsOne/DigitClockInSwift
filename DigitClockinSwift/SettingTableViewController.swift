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
  var delegate: DigitClockViewController?
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
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}

// MARK: Initialize
extension SettingTableViewController {
  func setup() {
    self.title = "Digit Clock"
    self.headerTitleList = getHeaderTitleList()
    self.initBarButton()
  }
  
  func initBarButton() {
    if self.respondsToSelector(Selector("pressedDoneBtn:")) {
      btnDone = UIBarButtonItem(
        barButtonSystemItem: .Done,
        target: self,
        action: Selector("pressedDoneBtn:"))
      
      self.navigationItem.setRightBarButtonItem(btnDone, animated: true)
    }
  }
  
  /*
  override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
  self.tableView.beginUpdates()
  if toInterfaceOrientation == UIInterfaceOrientation.Portrait {
  self.tableView.rowHeight = UITableViewAutomaticDimension
  } else {
  self.tableView.rowHeight = 80
  }
  self.tableView.endUpdates()
  }
  */
}

// MARK: UITableViewDataSource
extension SettingTableViewController {
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return kSectionCount
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == kMakerSectionIndex ? kMakerSectionRow : kDefaultRow
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell: SettingTableViewCell
      
      if indexPath.section == 1 {
        cell = tableView.dequeueReusableCellWithIdentifier(makerCellIdentifier,
          forIndexPath: indexPath)
          as! SettingMakerTableViewCell
        let makerCell = cell as! SettingMakerTableViewCell
        
        makerCell.makerLabel.text = self.getMakerText(indexPath.row)
        
      } else if indexPath.section == 2 {
        cell = tableView.dequeueReusableCellWithIdentifier(
          versionCellIdentifier,
          forIndexPath: indexPath)
          as! SettingVersionTableViewCell
        
        let versionCell = cell as! SettingVersionTableViewCell
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        versionCell.versionLabel.text = "Version : " + version
        
      } else {
        cell = tableView.dequeueReusableCellWithIdentifier(themeCellIdentifier, forIndexPath: indexPath)
          as! SettingThemeTableViewCell
      }
      
      cell.selectionStyle = .None
      cell.delegate = self
      
      return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return String?(self.headerTitleList[section]) ?? "Title"
  }
}

// MARK: UITableViewDelegate
extension SettingTableViewController {
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //    return UITableViewAutomaticDimension
    return 80.0
  }
}


// MARK: Touch/Gesture Handling
extension SettingTableViewController {
  func pressedDoneBtn(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  func selectedBackground(theme: UIColor) {
    if let delegate = delegate
      where delegate.respondsToSelector(Selector("updateBackground:")) {
        delegate.updateBackground(theme)
        if !UIDevice.currentDevice().model.hasPrefix("iPad") {
          self.dismissViewControllerAnimated(true, completion: nil)
        }
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