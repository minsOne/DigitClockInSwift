//
//  MainFeature.swift
//  MainFeature
//
//  Created by minsone on 2019/10/19.
//  Copyright © 2019 minsone. All rights reserved.
//

import Clock
import Settings
@_exported import Clock
@_exported import Settings

func binding_StaticLibrary_Bundle() {
    print(Clock.ViewController.self)
    print(Settings.ViewController.self)
}
