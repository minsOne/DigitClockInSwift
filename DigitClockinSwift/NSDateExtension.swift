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

extension NSDate {
  
  class func getNowDate() -> Date {
    let date = self()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(
      .CalendarUnitYear |
      .CalendarUnitDay |
      .CalendarUnitWeekday |
      .CalendarUnitHour |
      .CalendarUnitMinute |
      .CalendarUnitSecond,
      fromDate: date)
    
    return Date(
      year: components.year,
      month: components.month,
      day: components.day,
      weekday: components.weekday,
      hour: components.hour,
      minute: components.minute,
      second: components.second)
  }
}