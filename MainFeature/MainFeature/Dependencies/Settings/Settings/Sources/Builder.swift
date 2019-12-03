//
//  Builder.swift
//  Settings
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import RIBs
import Resources

public protocol Dependency: RIBs.Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

public final class Component: RIBs.Component<Dependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol Buildable: RIBs.Buildable {
    func build(withListener listener: Listener) -> Routing
}

public final class Builder: RIBs.Builder<Dependency>, Buildable {

    override public init(dependency: Dependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: Listener) -> Routing {
        let component = Component(dependency: dependency)
        let viewController: ViewController = R.Storyboard.settings.viewController()
        let interactor = Interactor(presenter: viewController)
        interactor.listener = listener
        return Router(interactor: interactor, viewController: viewController)
    }
}
