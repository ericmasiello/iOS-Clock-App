//
//  ContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI

enum NavigationDestinations: String, CaseIterable, Hashable {
  case Clock
  case Settings
}

struct ContentView: View {
  let screens = NavigationDestinations.allCases
  @State private var navigationPath = NavigationPath()

  var body: some View {
    NavigationStack(path: $navigationPath) {
      VStack(spacing: 40) {
        ForEach(screens, id: \.self) { screen in
          NavigationLink(value: screen) {
            Text(screen.rawValue)
          }
        }
      }
      .navigationTitle("Main View")
      .navigationDestination(for: NavigationDestinations.self) { screen in
        switch screen {
        case .Clock:
          HomeClockView() {
            navigationPath.removeLast()
          }
        case .Settings:
          SettingsView()
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
    .statusBar(hidden: true)
    .preferredColorScheme(.dark)
  }
}

#Preview {
  ContentView()
}
