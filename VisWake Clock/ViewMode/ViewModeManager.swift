//
//  ViewModeManager.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/1/24.
//

import Foundation

class ViewModeManager {
  static func mode(by current: Date, wakeup initialWakeup: Date, wakeupDuration: Double) -> ViewMode
  {
    /**
     * We need to normalize the day/month/year of current time and wakeup times. That way, we are only really concerned
     * with the hour/minute aspect of each
     */

    // store the desired wakeup hour and minutes
    let wakeupHour = Calendar.current.component(.hour, from: initialWakeup)
    let wakeupMinutes = Calendar.current.component(.minute, from: initialWakeup)

    // store the day, month, year from the current time
    let currentDateComponents = Calendar.current.dateComponents(
      [.day, .month, .year], from: current)

    // create a new wakeup time variable that matches the current date's day/month/year
    guard let wakeupBase = Calendar.current.date(from: currentDateComponents) else {
      return .dim
    }

    // set the wakeup time's desired hour and minutes
    guard
      let wakeupStart = Calendar.current.date(
        bySettingHour: wakeupHour, minute: wakeupMinutes, second: 0, of: wakeupBase)
    else {
      return .dim
    }
    // create a wakeup end time that uses the wakeup time and adds to it
    // the number of minutes in the configuration (must multiply by 60 to treat it as a minutes)
    let wakeupEnd = wakeupStart.addingTimeInterval(wakeupDuration * 60)

    if current >= wakeupStart && current <= wakeupEnd {
      return .active
    }

    return .dim
  }
}
