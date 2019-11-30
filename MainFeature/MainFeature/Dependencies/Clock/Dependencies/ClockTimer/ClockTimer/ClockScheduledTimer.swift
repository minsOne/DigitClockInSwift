//
//  ClockScheduledTimer.swift
//  ClockTimer
//
//  Created by minsone on 2019/11/30.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import Library

public protocol ClockScheduledTimerReceivable: class {
    func tick(clockDate: ClockDate)
}

public protocol ClockScheduledTimerable {
    func start()
    func stop()
    var receiver: ClockScheduledTimerReceivable? { get set }
}

public class ClockScheduledTimer: ClockScheduledTimerable {
    public weak var receiver: ClockScheduledTimerReceivable?
    var timer: Timer?
    deinit {
        stop()
    }
    public init() {}
    public func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [receiver] _ in
            receiver?.tick(clockDate: ClockDate.now)
        })
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
}
