//
//  UserConfiguration.swift
//  Clock It
//
//  Created by Eric Masiello on 11/19/24.
//

import Foundation
import SwiftData

@Model
class UserConfiguration {
  var wakeupTime: Date? = Date.now
  var wakeupDuration: Double = 45
  var isIdleTimerDisabled: Bool = true

  init(wakeupTime: Date) {
    self.wakeupTime = wakeupTime
  }
  
  init(wakeupTime: Date, wakeupDuration: Double) {
    self.wakeupTime = wakeupTime
    self.wakeupDuration = wakeupDuration
  }
  
  static func createWakeTime(hour: Int, minutes: Int) -> Date {
    
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minutes

    let specificTime = calendar.date(from: dateComponents)
    
    return specificTime!
  }
}
