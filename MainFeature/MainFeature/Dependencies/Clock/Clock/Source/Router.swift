//
//  Router.swift
//  Settings
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import RIBs
import Settings

public protocol Interactable: RIBs.Interactable, Settings.Listener {
    var router: Routing? { get set }
    var listener: Listener? { get set }
}

public protocol ViewControllable: RIBs.ViewControllable {
    func present(viewController: RIBs.ViewControllable)
}

public final class Router: RIBs.LaunchRouter<Interactable, ViewControllable>, Routing {
    public init(interactor: Interactable,
                viewController: ViewControllable,
                settingsBuilder: Settings.Buildable) {
        self._viewController = viewController
        self.settingsBuilder = settingsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    private let _viewController: ViewControllable
    private let settingsBuilder: Settings.Buildable
    private var settingsRouter: Settings.Routing?
    
    public func routeToSettings() {
        guard settingsRouter == nil else { return }
        let router: Settings.Routing = settingsBuilder.build(withListener: interactor)
        viewController.present(viewController: router.viewControllable)
        attachChild(router)
        settingsRouter = router
    }
    
    public func detachSettings() {
        guard let router = settingsRouter else { return }
        detachChild(router)
        settingsRouter = nil
    }
}
