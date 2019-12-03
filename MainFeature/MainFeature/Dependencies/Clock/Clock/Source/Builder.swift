//
//  Builder.swift
//  Settings
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import RIBs
import Settings
import Resources

public protocol Dependency: RIBs.Dependency {}

public final class Component: RIBs.Component<Dependency>, Settings.Dependency {
    fileprivate let colorStorageSerive: ColorStorageService

    init(colorStorageSerive service: ColorStorageService,
         dependency: Dependency) {
        self.colorStorageSerive = service
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol Buildable: RIBs.Buildable {
    func build(colorStorageSerive: ColorStorageService) -> LaunchRouting
}

public final class Builder: RIBs.Builder<Dependency>, Buildable {
    
    override public init(dependency: Dependency) {
        super.init(dependency: dependency)
    }
    
    public func build(colorStorageSerive service: ColorStorageService) -> LaunchRouting {
        let component = Component(colorStorageSerive: service,
                                  dependency: dependency)
        let viewController: ViewController = R.Storyboard.clock.viewController()
        viewController.colorStorageService = service
        let interactor = Interactor(presenter: viewController)
        
        let settingsBuilder = Settings.Builder(dependency: component)
        return Router(interactor: interactor,
                      viewController: viewController,
                      settingsBuilder: settingsBuilder)
    }
}
