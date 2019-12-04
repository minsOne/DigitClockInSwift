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
import ClockTimer
import RIBs

private let spaceViewAlpha: CGFloat = 0.5

public enum PresentableListenerAction {
    case tappedSettingButton
    case viewDidLoad
}

public protocol PresentableListener: class {
    func action(action: PresentableListenerAction)
}

final public class ViewController: UIViewController, Instantiable, Presentable, ViewControllable {
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
    
    public weak var listener: PresentableListener?
    
    private var clockTimer: ClockScheduledTimerable?
    private var spaceViewTimer: SpaceViewScheduledTimerable?
    
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
        clockTimer?.stop()
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
        initSpaceView()
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
    
    func addTapGesture() {
        let singleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleSingleTap))
        view.addGestureRecognizer(singleTap)
    }
    
    func addPanGesuture() {
        let selector = #selector(displayGestureForPanGestureRecognizer)
        let pan = UIPanGestureRecognizer( target: self, action: selector)
        view.addGestureRecognizer(pan)
    }
    
    func addSettingButtonTapAction() {
        let selector = #selector(presentSettingViewController(sender:))
        settingButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    @objc func presentSettingViewController(sender: UIButton) {
        listener?.action(action: .tappedSettingButton)
    }
    
    public func present(viewController: RIBs.ViewControllable) {
        let nc = UINavigationController(rootViewController: viewController.uiviewController)
        if #available(iOS 13.0, *) {
            nc.isModalInPresentation = true
        }
        nc.modalPresentationStyle = .popover
        nc.popoverPresentationController?.permittedArrowDirections = .any
        nc.popoverPresentationController?.sourceView = self.view
        let sourceRect = view.convert(settingButton.frame, from: settingButton.superview)
        nc.popoverPresentationController?.sourceRect = sourceRect
        
        present(nc, animated: true, completion: nil)
    }
    
    public func dismiss(viewController: RIBs.ViewControllable) {
        viewController.uiviewController.dismiss(animated: true, completion: nil)
    }
    
    func initSpaceView() {
        spaceView.layer.cornerRadius = 4
    }
}

// MARK: View Handling
extension ViewController {
    override public var prefersStatusBarHidden: Bool { true }
    
    func updateSpaceView() {
        spaceView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.7) { [spaceView, isTouch] in
            spaceView?.alpha = isTouch ? spaceViewAlpha : 0
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
        
        if UIDevice.isIPad {
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
        case .changed:
            changeViewAlpha(nowPoint: translation)
        case .cancelled, .ended, .failed, .possible:
            fallthrough
        default:
            lastTranslation = nil
        }
    }
}


// MARK: Time Handling
extension ViewController: ClockScheduledTimerReceivable, SpaceViewScheduledTimerReceivable {
    func onTickTimer() {
        clockTimer = ClockScheduledTimer()
        clockTimer?.receiver = self
        clockTimer?.start()
    }
    
    public func tick(clockDate date: ClockDate) {
        weekday = date.weekday
        
        let timeList = getTimeList(hour: date.hour,
                                   minute: date.minute,
                                   second: date.second)
        let fn = setDigitContentRect
        UIView.animate(withDuration: 1.0) { [weak self] in
            guard let self = self else { return }
            var count = 0
            timeList.forEach {
                fn($0, self.timeImageViews[count])
                count += 1
            }
            self.colonImageViews
                .forEach {
                    $0.alpha = (Int($0.alpha) == 1 ? 0.2 : 1.0)
            }
        }
    }
    
    func onSpaceViewTimer() {
        spaceViewTimer = SpaceViewScheduledTimer()
        spaceViewTimer?.receiver = self
        spaceViewTimer?.start()
    }
    
    func offSpaceViewTimer() {
        spaceViewTimer?.stop()
    }
    
    public func tickSpaceView() {
        offSpaceViewTimer()
        isTouch = false
    }
}

private func getTimeList(hour h: Int, minute m: Int, second s: Int) -> [Int] {
    var timeLists: [Int] = []
    timeLists += [h / 10]
    timeLists += [h % 10]
    timeLists += [m / 10]
    timeLists += [m % 10]
    timeLists += [s / 10]
    timeLists += [s % 10]
    return timeLists
}

private func asyncUI(f: @escaping () -> Void) {
    DispatchQueue.main.async(execute: f)
}
