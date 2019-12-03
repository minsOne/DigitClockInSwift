//
//  TimerService.swift
//  Clock
//
//  Created by minsone on 2019/12/01.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import ClockTimer
import Library

protocol TimerServiciable {
    func setSpaceViewTimerRecevier(receiver: SpaceViewScheduledTimerReceivable)
    func setClockScheduledTimerReceiver(receiver: ClockScheduledTimerReceivable)
    func startClockTimer()
    func startSpaceViewTimer()
    func stopSpaceViewTimer()
}

class TimerService {
    var clockTimer: ClockScheduledTimerable?
    var spaceViewTimer: SpaceViewScheduledTimerable?
    init() {}
    
    func setSpaceViewTimerRecevier(receiver: SpaceViewScheduledTimerReceivable) {
        self.spaceViewTimer?.receiver = receiver
    }
    
    func setClockScheduledTimerReceiver(receiver: ClockScheduledTimerReceivable) {
        self.clockTimer?.receiver = receiver
    }
    
    func startClockTimer() {
        if let timer = clockTimer {
            timer.stop()
        }
    }
}
