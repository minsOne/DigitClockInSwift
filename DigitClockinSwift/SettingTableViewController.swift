//
//  SettingTableViewController.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 25..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

  // MARK: Properties
  var btnDone: UIBarButtonItem?
  
}

// MARK: View Life Cycle
extension SettingTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("pressedDoneBtn:"))
    
    self.navigationItem.setRightBarButtonItem(btnDone, animated: true)
    
    self.title = "Digit Clock"

  }
}
// MARK: Memory Handling
extension SettingTableViewController {
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: Table View Data Source
extension SettingTableViewController {
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCellWithIdentifier(themeCellIdentifier, forIndexPath: indexPath) as! ThemeTableViewCell
  
  // Configure the cell...
  return cell
  }
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100.0
  }
}

// MARK: Navigation
extension SettingTableViewController {
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  }
}

extension SettingTableViewController {
  func pressedDoneBtn(sender: UIBarButtonItem) {
//    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
