//
//  ViewController.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 22..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

let digitName = "Digits"

class DigitClockViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var weekView: UIView!
  @IBOutlet weak var spaceView: UIView!
  @IBOutlet weak var timeView: UIView!
  
  @IBOutlet var weekLabels: [UILabel]!
  @IBOutlet var timeImageViews: [UIImageView]!
  @IBOutlet var colonImageViews: [UIImageView]!
  
  @IBOutlet weak var rotationButton: UIButton!
  
  weak var timer: NSTimer?
  
  deinit {
    self.offTickTimer()
  }
}

// MARK: View Life Cycle
extension DigitClockViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    if UIDevice.currentDevice().orientation.isLandscape.boolValue {
      println("Now Device Orientation is Landscape")
//      dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        self.rotationButton.alpha = 1.0
//      })
    } else {
      println("Now Device Orientation is Portrait")
//      dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        self.rotationButton.alpha = 0.0
//      })
    }
  }
}

// MARK: Initial View Handling
extension DigitClockViewController {
  func setup() {
    self.initWeekLabel()
    self.initTimeView()
    self.initColonView()
    self.onTickTimer()
  }
  
  func initTimeView() {
    self.timeImageViews.map {
      self.setDigitImageLayer(0, forView: $0)
    }
  }
  
  func initColonView() {
    self.colonImageViews.map {
      self.setDigitImageLayer(10, forView: $0)
    }
  }
  
  func initWeekLabel() {
    var count = 1
    let (weekday, _, _, _) = getDate()
    self.weekLabels.map { (label: UILabel) -> UILabel in
      label.tag = count++
      label.alpha = (label.tag == weekday) ? 1.0 : 0.2
      return label
    }
  }
  func initRotationButton() {
    self.rotationButton.alpha = 0.0
  }
  
  private func setDigitImageLayer(xPosition: Int, forView view: UIImageView) {
    view.layer.contents = UIImage(named: digitName)?.CGImage
    view.layer.contentsGravity = kCAGravityResizeAspect
    view.layer.magnificationFilter = kCAFilterNearest
    self.setDigitContentRect(xPosition, forView: view)
  }
  
  private func setDigitContentRect(xPosition: Int, forView view: UIImageView) {
    view.layer.contentsRect = CGRect(x: Double(xPosition)/11.0,
      y: 0,
      width: 1.0/11.0,
      height: 1.0)
  }
}

// MARK: Time Handling
extension DigitClockViewController {
  func onTickTimer() {
    self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
      target: self,
      selector: Selector("tick"),
      userInfo: nil,
      repeats: true)
  }
  
  func offTickTimer() {
    self.timer?.invalidate()
    self.timer = nil
  }
  
  func tick() {
    let (weekday, hours, minutes, seconds) = self.getDate()
    let timeList = getTimeList(hours, minutes: minutes, seconds: seconds)
    
    self.weekLabels.map { (label: UILabel) -> UILabel in
      label.alpha = (label.tag == weekday) ? 1.0 : 0.2
      return label
    }
    
    UIView.animateWithDuration(1.0) {
      for (index, time) in enumerate(timeList) {
        self.setDigitContentRect(time, forView: self.timeImageViews[index])
      }
      self.colonImageViews.map { (iView: UIImageView) -> UIImageView in
        iView.alpha = (iView.alpha == 1.0) ? 0.2 : 1.0
        return iView
      }
    }
  }
}


// MARK: Memory Handling
extension DigitClockViewController {
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: Util Methods
extension DigitClockViewController {
  func getTimeList(hours: Int, minutes: Int, seconds: Int) -> [Int] {
    var timeLists: [Int] = []
    timeLists += [hours / 10]
    timeLists += [hours % 10]
    timeLists += [minutes / 10]
    timeLists += [minutes % 10]
    timeLists += [seconds / 10]
    timeLists += [seconds % 10]
    return timeLists
  }
  
  func getDate() -> (Int, Int, Int, Int) {
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
    
    let weekday = components.weekday
    let hour = components.hour
    let minutes = components.minute
    let seconds = components.second
    
    return (weekday, hour, minutes, seconds)
  }
}
