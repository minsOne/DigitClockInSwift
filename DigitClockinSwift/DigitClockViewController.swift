//
//  ViewController.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 22..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit

enum ImageName: String {
  case Digits = "Digits"
  case RotationLock = "rotation_lock"
  case RotationUnLock = "rotation_unlock"
}

let spaceViewAlpha: CGFloat = 0.5

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
  
  var isRotate: Bool = true {
    didSet { self.updateRotateLockButtonImage() }
  }
  
  var isTouch: Bool = false {
    didSet { self.updateSpaceView() }
  }
  
  var weekday: Int = 0 {
    didSet { self.updateWeekLabel() }
  }
  
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
}

// MARK: Initialize
extension DigitClockViewController {
  func setup() {
    self.initWeekLabel()
    self.initTimeView()
    self.initColonView()
    self.initRotationBtn()
    self.onTickTimer()
    self.addTapGesture()
  }
  
  func initTimeView() {
    let f = self.setDigitImageLayer
    self.timeImageViews.map { f(0, forView: $0) }
  }
  
  func initColonView() {
    let f = self.setDigitImageLayer
    self.colonImageViews.map { f(10, forView: $0) }
  }
  
  func initWeekLabel() {
    var count = 1
    self.weekday = NSDate.getNowDate().weekday
    self.weekLabels.map { (label) -> UILabel in
      label.tag = count++
      label.alpha = (label.tag == self.weekday) ? 1.0 : 0.2
      return label
    }
  }
  
  func initRotationBtn() {
    if self.respondsToSelector( Selector("pressedRotationBtn:") ) {
      self.rotationButton.addTarget(
        self,
        action: Selector("pressedRotationBtn:"),
        forControlEvents: .TouchUpInside)
    }
  }
  
  func addTapGesture() {
    if self.respondsToSelector( Selector("handleSingleTap:") ) {
      var singleTap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: Selector("handleSingleTap:"))
      
      self.view.addGestureRecognizer(singleTap)
    }
  }
}

// MARK: View Handling
extension DigitClockViewController {
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  func updateSpaceView() {
    let f: (NSTimeInterval, () -> ()) -> () = {
      self.spaceView.layer.removeAllAnimations()
      UIView.animateWithDuration($0, animations: $1)
    }
    
    if self.isTouch {
      f(0.7) { self.spaceView.alpha = spaceViewAlpha }
    } else {
      f(0.7) { self.spaceView.alpha = 0 }
    }
  }
  
  func updateRotateLockButtonImage() {
    dispatch_async( dispatch_get_main_queue() ) {
      let rotationBtnName = self.isRotate ? ImageName.RotationUnLock.rawValue : ImageName.RotationLock.rawValue
      self.rotationButton.imageView?.image = UIImage(named: rotationBtnName)
      
    }
  }
  
  func updateWeekLabel() {
    dispatch_async( dispatch_get_main_queue() ) {
      self.weekLabels.map {
        $0.alpha = ($0.tag == self.weekday ? 1.0 : 0.2)
      }
    }
  }
  
  func setDigitImageLayer(xPosition: Int, forView view: UIImageView) {
    view.layer.contents = UIImage(named: ImageName.Digits.rawValue)?.CGImage
    view.layer.contentsGravity = kCAGravityResizeAspect
    view.layer.magnificationFilter = kCAFilterNearest
    
    self.setDigitContentRect(xPosition, forView: view)
  }
  
  func setDigitContentRect(xPosition: Int, forView view: UIImageView) {
    view.layer.contentsRect = CGRect(
      x: Double(xPosition)/11.0,
      y: 0,
      width: 1.0/11.0,
      height: 1.0)
  }
}

// MARK: View Rotate
extension DigitClockViewController {
  override func shouldAutorotate() -> Bool {
    return isRotate
  }
}

// MARK: Touch/Gesture Handling
extension DigitClockViewController {
  func handleSingleTap(recognizer: UITapGestureRecognizer) {
    self.isTouch = !self.isTouch
  }
  
  func pressedRotationBtn(sender: UIButton) {
    self.isRotate = !self.isRotate
  }
}


// MARK: Time Handling
extension DigitClockViewController {
  func onTickTimer() {
    self.timer = NSTimer.scheduledTimerWithTimeInterval(
      1.0,
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
    let date = NSDate.getNowDate()
    
    self.weekday = date.weekday
    
    UIView.animateWithDuration(1.0) {
      var count = 0
      let f = self.setDigitContentRect
      let timeList = self.getTimeList(
        hour: date.hour,
        minute: date.minute,
        second: date.second)
      
      timeList.map { f($0, forView: self.timeImageViews[count++]) }
      self.colonImageViews.map {
        $0.alpha = ($0.alpha == 1.0 ? 0.2 : 1.0)
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
  func getTimeList(#hour: Int, minute: Int, second: Int) -> [Int] {
    var timeLists: [Int] = []
    timeLists += [hour / 10]
    timeLists += [hour % 10]
    timeLists += [minute / 10]
    timeLists += [minute % 10]
    timeLists += [second / 10]
    timeLists += [second % 10]
    return timeLists
  }
}
