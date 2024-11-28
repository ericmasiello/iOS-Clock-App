//
//  Clock_ItApp.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI
import SwiftData

@main
struct Clock_ItApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: UserConfiguration.self)
    }
}
