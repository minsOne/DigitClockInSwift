//
//  ViewController.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 22..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import UIKit
import Resources
import Library
import Settings

private let spaceViewAlpha: CGFloat = 0.5

final public class ViewController: UIViewController, Instantiable, Settings.Listener {
    public static var storyboardName: String { "ClockViewController" }
    
    // MARK: Properties
    @IBOutlet private weak var weekView: UIView!
    @IBOutlet private weak var spaceView: UIView!
    @IBOutlet private weak var timeView: UIView!
    
    @IBOutlet private var weekLabels: [UILabel]!
    @IBOutlet private var timeImageViews: [UIImageView]!
    @IBOutlet private var colonImageViews: [UIImageView]!
    
    @IBOutlet private weak var rotationButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    
    private weak var timeViewtimer: Timer?
    private weak var spaceViewTimer: Timer?
    
    private var lastTranslation: CGPoint?
    
    private var isRotate: Bool = true {
        didSet { self.updateRotateLockButtonImage() }
    }
    
    private var isTouch: Bool = false {
        didSet { self.updateSpaceView() }
    }
    
    private var weekday: Int = 0 {
        didSet { self.updateWeekLabel() }
    }
    
    var baseColor = UIColor(red:1, green:0.19, blue:0.12, alpha:1)
    
    public var colorStorageService: ColorStorageService?
    
    deinit {
        offTickTimer()
        offSpaceViewTimer()
    }
}

// MARK: View Life Cycle
extension ViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: Initialize
extension ViewController {
    func setup() {
        initBackgroundView()
        initWeekLabel()
        initTimeView()
        initColonView()
        initRotationBtn()
        initSettingBtn()
        onTickTimer()
        addTapGesture()
        addPanGesuture()
        updateRotateLockButtonImage()
        addSettingButtonTapAction()
    }
    
    private func initBackgroundView() {
        view.backgroundColor = colorStorageService?.initBackgroundColor
            ?? baseColor
    }
    
    private func initTimeView() {
        let f = setDigitImageLayer
        timeImageViews.forEach { f(0, $0) }
    }
    
    private func initColonView() {
        let f = setDigitImageLayer
        colonImageViews.forEach { f(10, $0) }
    }
    
    private func initWeekLabel() {
        var count = 1
        
        weekday = ClockDate.now.weekday
        weekLabels.forEach { label in
            label.tag = count
            label.alpha = (label.tag == self.weekday) ? 1.0 : 0.2
            count += 1
        }
    }
    
    func initRotationBtn() {
        guard responds(to: #selector(pressedRotationBtn)) else { return }
        
        rotationButton.addTarget(self,
                                 action: #selector(pressedRotationBtn),
                                 for: .touchUpInside)
    }
    
    func initSettingBtn() {
        settingButton.setImage(R.Image.menuSettingsBt, for: .normal)
    }
    
    func addTapGesture() {
        guard responds(to: #selector(handleSingleTap)) else { return }
        
        let singleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleSingleTap))
        view.addGestureRecognizer(singleTap)
    }
    
    func addPanGesuture() {
        guard responds(to: #selector(displayGestureForPanGestureRecognizer))
            else { return }
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(displayGestureForPanGestureRecognizer))
        view.addGestureRecognizer(pan)
    }
    
    func addSettingButtonTapAction() {
        guard responds(to: #selector(presentSettingViewController(sender:))) else { return }
        settingButton.addTarget(self,
                                action: #selector(presentSettingViewController(sender:)),
                                for: .touchUpInside)
    }
    
    @objc func presentSettingViewController(sender: UIButton) {
        let vc = Settings.ViewController.instance
        vc.listener = self
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .popover
        nc.popoverPresentationController?.permittedArrowDirections = .any
        nc.popoverPresentationController?.sourceView = self.view
        nc.popoverPresentationController?.sourceRect = view.convert(sender.frame, from: sender.superview)
        
        present(nc, animated: true, completion: nil)
    }
}

// MARK: View Handling
extension ViewController {
    override public var prefersStatusBarHidden: Bool { true }
    
    func updateSpaceView() {
        let f: ((TimeInterval, @escaping () -> (Void)) -> Void) = { timeInterval, closure in
            self.spaceView.layer.removeAllAnimations()
            UIView.animate(withDuration: timeInterval, animations: closure)
        }
        
        if isTouch {
            f(0.7) { self.spaceView.alpha = spaceViewAlpha }
        } else {
            f(0.7) { self.spaceView.alpha = 0 }
        }
    }
    
    func updateRotateLockButtonImage() {
        let isRotate = self.isRotate
        asyncUI {
            let rotationImage = isRotate
                ? R.Image.rotationUnLock
                : R.Image.rotationLock
            self.rotationButton.setImage(rotationImage, for: .normal)
        }
    }
    
    func updateWeekLabel() {
        let weekLabels = self.weekLabels
        asyncUI {
            weekLabels?.forEach {
                $0.alpha = ($0.tag == self.weekday ? 1.0 : 0.2)
            }
        }
    }
    
    public func update(color: UIColor) {
        asyncUI { self.view.backgroundColor = color }
        colorStorageService?.store(color: color)
    }
    
    func setDigitImageLayer(xPosition: Int, forView view: UIImageView) {
        view.image = R.Image.digits
        view.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        view.layer.magnificationFilter = .nearest
        
        setDigitContentRect(xPosition: xPosition, forView: view)
    }
    
    func setDigitContentRect(xPosition: Int, forView view: UIImageView) {
        view.layer.contentsRect = CGRect(x: Double(xPosition)/11.0, y: 0, width: 1.0/11.0, height: 1.0)
    }
}

// MARK: View Rotate
extension ViewController {
    override public var shouldAutorotate: Bool { isRotate }
}

// MARK: Touch/Gesture Handling
extension ViewController {
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer) {
        isTouch.toggle()
        
        if !UIDevice.current.model.hasPrefix("iPad") {
            isTouch ? onSpaceViewTimer() : offSpaceViewTimer()
        }
    }
    
    @objc func pressedRotationBtn(sender: UIButton) {
        isRotate.toggle()
        
        offSpaceViewTimer()
        onSpaceViewTimer()
    }
    
    func changeViewAlpha(nowPoint: CGPoint) {
        defer { lastTranslation = nowPoint }
        
        guard
            let lastPoint = lastTranslation,
            case let alpha = view.alpha
            else { return }
        
        if lastPoint.y > nowPoint.y && alpha < 1.0 {
            view.alpha = alpha + 0.01
        } else if lastPoint.y < nowPoint.y && alpha >= 0.02 {
            view.alpha = alpha - 0.01
        }
    }
    
    @objc func displayGestureForPanGestureRecognizer(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            lastTranslation = translation
            break
        case .changed:
            changeViewAlpha(nowPoint: translation)
            break
        case .cancelled, .ended, .failed, .possible:
            fallthrough
        default:
            lastTranslation = nil
        }
    }
}


// MARK: Time Handling
extension ViewController {
    func onTickTimer() {
        self.timeViewtimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true)
    }
    
    func offTickTimer() {
        self.timeViewtimer?.invalidate()
        self.timeViewtimer = nil
    }
    
    @objc func tick() {
        let date = ClockDate.now
        self.weekday = date.weekday
        
        UIView.animate(withDuration: 1.0) {
            var count = 0
            let f = self.setDigitContentRect
            let timeList = self.getTimeList(hour: date.hour, minute: date.minute, second: date.second)
            
            timeList.forEach {
                f($0, self.timeImageViews[count])
                count += 1
            }
            self.colonImageViews.forEach { $0.alpha = ($0.alpha == 1.0 ? 0.2 : 1.0) }
        }
    }
    
    func onSpaceViewTimer() {
        guard responds(to: #selector(fadeSpaceView))
            else { return }
        
        spaceViewTimer = Timer.scheduledTimer(
            timeInterval: 4.0,
            target: self,
            selector: #selector(fadeSpaceView),
            userInfo: nil,
            repeats: false)
    }
    
    func offSpaceViewTimer() {
        spaceViewTimer?.invalidate()
        spaceViewTimer = nil
    }
    
    @objc func fadeSpaceView() {
        offSpaceViewTimer()
        isTouch = false
    }
}

// MARK: Util Methods
extension ViewController {
    func getTimeList(hour h: Int, minute m: Int, second s: Int) -> [Int] {
        var timeLists: [Int] = []
        timeLists += [h / 10]
        timeLists += [h % 10]
        timeLists += [m / 10]
        timeLists += [m % 10]
        timeLists += [s / 10]
        timeLists += [s % 10]
        return timeLists
    }
    
    func asyncUI(f: @escaping () -> Void) {
        DispatchQueue.main.async(execute: f)
    }
    
    func asyncLogic(f: @escaping () -> Void) {
        DispatchQueue.global().async(execute: f)
    }
}
