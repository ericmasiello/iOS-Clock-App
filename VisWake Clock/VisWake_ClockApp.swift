//
//  VisWake_ClockApp.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftData
import Sentry

import SwiftUI

@main
struct VisWake_ClockApp: App {
    init() {
        SentrySDK.start { options in
            options.dsn = "https://8a8857516c36a9daf0014ff6e680d6bd@o218382.ingest.us.sentry.io/4508480854032384"
            options.debug = true // Enabled debug when first installing is always helpful
            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0

            // Sample rate for profiling, applied on top of TracesSampleRate.
            // We recommend adjusting this value in production.
            options.profilesSampleRate = 1.0 

            // Uncomment the following lines to add more data to your events
             options.attachScreenshot = true // This adds a screenshot to the error events
             options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
        // Remove the next line after confirming that your Sentry integration is working.
        SentrySDK.capture(message: "This app uses Sentry! :)")
    }
  var body: some Scene {
    WindowGroup {
      DataResolverView()
    }
    .modelContainer(for: UserConfiguration.self)
  }
}
