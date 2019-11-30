//
//  SpaceViewScheduledTimer.swift
//  ClockTimer
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation

public protocol SpaceViewScheduledTimerReceivable: class {
    func tickSpaceView()
}

public protocol SpaceViewScheduledTimerable {
    func start()
    func stop()
    var receiver: SpaceViewScheduledTimerReceivable? { get set }
}

public class SpaceViewScheduledTimer: SpaceViewScheduledTimerable {
    public weak var receiver: SpaceViewScheduledTimerReceivable?
    var timer: Timer?
    deinit {
        stop()
    }
    public init() {}
    public func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { [receiver] _ in
            receiver?.tickSpaceView()
        })
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
}
