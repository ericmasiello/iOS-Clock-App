//
//  VisWake_ClockApp.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftData
import SwiftUI

@main
struct VisWake_ClockApp: App {
  var body: some Scene {
    WindowGroup {
      DataResolverView()
    }
    .modelContainer(for: UserConfiguration.self)
  }
}
