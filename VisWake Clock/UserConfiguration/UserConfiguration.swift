//
//  UserConfiguration.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/19/24.
//

import Foundation
import SwiftData

struct CountdownEvent: Codable, Identifiable, Equatable {
  var id = UUID()
  var date: Date
  var name: String
}

@Model
class UserConfiguration {
  var wakeupTime: Date? = Date.now
  var wakeupDuration: Double = 45
  var isIdleTimerDisabled: Bool = true
  var countdownEvents: [CountdownEvent] = []

  init(wakeupTime: Date) {
    self.wakeupTime = wakeupTime
  }

  init(wakeupTime: Date, wakeupDuration: Double) {
    self.wakeupTime = wakeupTime
    self.wakeupDuration = wakeupDuration
  }
  
  var sortedCountdownEvents: [CountdownEvent] {
    countdownEvents.sorted(by: { $0.date < $1.date })
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
