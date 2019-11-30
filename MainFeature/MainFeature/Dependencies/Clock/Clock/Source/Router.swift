//
//  Router.swift
//  Settings
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import RIBs

public protocol Interactable: RIBs.Interactable {
    var router: Routing? { get set }
    var listener: Listener? { get set }
}

public protocol ViewControllable: RIBs.ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

public final class Router: ViewableRouter<Interactable, ViewControllable>, Routing {

    // TODO: Constructor inject child builder protocols to allow building children.
    public override init(interactor: Interactable, viewController: ViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
