//
//  Clock_ItApp.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftData
import SwiftUI

@main
struct Clock_ItApp: App {
  var body: some Scene {
    WindowGroup {
      DataResolverView()
    }
    .modelContainer(for: UserConfiguration.self)
  }
}
