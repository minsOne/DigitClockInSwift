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
  @IBOutlet weak var settingButton: UIButton!
  
  weak var timeViewtimer: NSTimer?
  weak var spaceViewTimer: NSTimer?
  
  var lastTranslation: CGPoint?
  
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
    self.offSpaceViewTimer()
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
    self.initBackgroundView()
    self.initWeekLabel()
    self.initTimeView()
    self.initColonView()
    self.initRotationBtn()
    self.onTickTimer()
    self.addTapGesture()
    self.addPanGesuture()
  }
  
  func initBackgroundView() {
    let theme = ThemeColor.initialThemeColor()
    if let nowTheme = theme.nowTheme {
      self.view.backgroundColor = nowTheme
    } else {
      let initTheme = ThemeColor.getThemeColorList().first
      self.view.backgroundColor = initTheme
      ThemeColor.sharedInstance.nowTheme = initTheme
    }
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
  
  func addPanGesuture() {
    if self.respondsToSelector(Selector("displayGestureForPanGestureRecognizer:")) {
      var pan = UIPanGestureRecognizer(
        target: self, 
        action: Selector("displayGestureForPanGestureRecognizer:"))
      self.view.addGestureRecognizer(pan)
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
    self.asyncUI {
      let rotationBtnName = self.isRotate ? ImageName.RotationUnLock.rawValue : ImageName.RotationLock.rawValue
      self.rotationButton.imageView?.image = UIImage(named: rotationBtnName)
    }
  }
  
  func updateWeekLabel() {
    self.asyncUI {
      self.weekLabels.map {
        $0.alpha = ($0.tag == self.weekday ? 1.0 : 0.2)
      }
    }
  }

  func updateBackground(theme: UIColor) {
    self.asyncUI { self.view.backgroundColor = theme }
    ThemeColor.sharedInstance.nowTheme = theme
    ThemeColor.storeThemeColor(ThemeColor.sharedInstance)
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

    if !UIDevice.currentDevice().model.hasPrefix("iPad") {
      self.isTouch ? self.onSpaceViewTimer() : self.offSpaceViewTimer()
    }
  }
  
  func pressedRotationBtn(sender: UIButton) {
    self.isRotate = !self.isRotate
  }
  func changeViewAlpha(nowPoint: CGPoint) {
    let alpha = self.view.alpha
    
    if let lastPoint = lastTranslation {
      if lastPoint.y > nowPoint.y && alpha < 1.0 {
        self.view.alpha = alpha + 0.01
      } else if lastPoint.y < nowPoint.y && alpha >= 0.02 {
        self.view.alpha = alpha - 0.01
      }
    }
    lastTranslation = nowPoint
  }
  
  func displayGestureForPanGestureRecognizer(sender: UIPanGestureRecognizer) {
    let translation = sender.translationInView(self.view)
    
    switch (sender.state) {
    case .Began:
      lastTranslation = translation
      break
    case .Changed:
      self.changeViewAlpha(translation)
      break
    case .Cancelled:
      fallthrough
    case .Ended:
      fallthrough
    case .Failed:
      fallthrough
    case .Possible:
      fallthrough
    default:
      lastTranslation = nil
    }
  }
}


// MARK: Time Handling
extension DigitClockViewController {
  func onTickTimer() {
    self.timeViewtimer = NSTimer.scheduledTimerWithTimeInterval(
      1.0,
      target: self,
      selector: Selector("tick"),
      userInfo: nil,
      repeats: true)
  }
  
  func offTickTimer() {
    self.timeViewtimer?.invalidate()
    self.timeViewtimer = nil
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
      self.colonImageViews.map { $0.alpha = ($0.alpha == 1.0 ? 0.2 : 1.0) }
    }
  }

  func onSpaceViewTimer() {
    if self.respondsToSelector( Selector("fadeSpaceView") ) {
      self.spaceViewTimer = NSTimer.scheduledTimerWithTimeInterval(
        4.0, 
        target: self, 
        selector: Selector("fadeSpaceView"), 
        userInfo: nil,
        repeats: false)
    }
  }

  func offSpaceViewTimer() {
    self.spaceViewTimer?.invalidate()
    self.spaceViewTimer = nil
  }

  func fadeSpaceView() {
    self.offSpaceViewTimer()
    self.isTouch = false
  }
}

// MARK: Segue
extension DigitClockViewController {
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toSettingVC" {
      let destinationNavigationController = segue.destinationViewController as! UINavigationController
      let targetController =
      destinationNavigationController.topViewController as! SettingTableViewController

      targetController.delegate = self
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

  func asyncUI( f:() -> Void ) {
    dispatch_async( dispatch_get_main_queue() ) {
      f()
    }
  }

  func asyncLogic( f:() -> Void ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      f()
    }
  }
}
