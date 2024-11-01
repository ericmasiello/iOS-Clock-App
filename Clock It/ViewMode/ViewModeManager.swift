//
//  ViewModeManager.swift
//  Clock It
//
//  Created by Eric Masiello on 11/1/24.
//

import Foundation

class ViewModeManager {
  static func mode(by date: Date) -> ViewMode {
    let hour = date.component(.hour)
    let minutes = date.component(.minute)
    /**
     * Set full opacity if time >= 6:15 and < 8:00 am
     */
    return switch (hour, minutes) {
    case (6, let mins) where mins >= 15, (7, let mins):
      .active
    default:
      .dim
    }
  }
}
