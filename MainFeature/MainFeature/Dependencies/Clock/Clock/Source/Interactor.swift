//
//  Interactor.swift
//  Settings
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import RIBs
import RxSwift

public protocol Routing: ViewableRouting {
    func routeToSettings()
    func detachSettings()
}

public protocol Presentable: RIBs.Presentable {
    var listener: PresentableListener? { get set }
    func update(color: UIColor)
}

public protocol Listener: class {}

public final class Interactor: RIBs.PresentableInteractor<Presentable>, Interactable, PresentableListener {
    public weak var router: Routing?
    public weak var listener: Listener?

    public override init(presenter: Presentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    public override func didBecomeActive() {
        super.didBecomeActive()
    }

    public override func willResignActive() {
        super.willResignActive()
    }
    
    public func update(color: UIColor) {
        presenter.update(color: color)
    }
    
    public func finishSelectColor() {
        router?.detachSettings()
    }
    
    public func action(action: PresentableListenerAction) {
        switch action {
        case .tappedSettingButton: router?.routeToSettings()
        case .viewDidLoad: viewDidLoad()
        }
    }
    
    func viewDidLoad() {
        
    }
}
