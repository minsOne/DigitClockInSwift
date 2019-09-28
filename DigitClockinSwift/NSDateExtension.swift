//
//  NSDateExtension.swift
//  DigitClockinSwift
//
//  Created by minsOne on 2015. 4. 29..
//  Copyright (c) 2015년 minsOne. All rights reserved.
//

import Foundation

struct Date {
  var year = 0, month = 0, day = 0, weekday = 0, hour = 0, minute = 0, second = 0
  init() {}
  init(year: Int, month: Int, day: Int, weekday: Int, hour: Int, minute: Int, second: Int) {
    self.init()
    self.year = year
    self.month = month
    self.day = day
    self.weekday = weekday
    self.hour = hour
    self.minute = minute
    self.second = second
  }
}

extension Date {
  static func getNowDate() -> Date {
    let date = Foundation.Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .day, .weekday, .hour, .minute, .second], from: date)
    
    return Date(
      year: components.year ?? 0,
      month: components.month ?? 0,
      day: components.day ?? 0,
      weekday: components.weekday ?? 0,
      hour: components.hour ?? 0,
      minute: components.minute ?? 0,
      second: components.second ?? 0)
  }
}
