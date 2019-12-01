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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

public protocol Presentable: RIBs.Presentable {
    var listener: PresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol Listener: class {
    func update(color: UIColor)
    func finishSelectColor()
}

public final class Interactor: RIBs.PresentableInteractor<Presentable>, Interactable, PresentableListener {
    public weak var router: Routing?
    public weak var listener: Listener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    public override init(presenter: Presentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    public override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    public override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    public func update(color: UIColor) {
        listener?.update(color: color)
    }

    public func done() {
        listener?.finishSelectColor()
    }
}
