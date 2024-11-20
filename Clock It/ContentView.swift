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
  
  // makes the Clock view the initial view
  @State private var navigationPath = NavigationPath([NavigationDestinations.Clock])
  @State private var isIdleTimerDisabled: Bool = true

  var body: some View {
    NavigationStack(path: $navigationPath) {
      
      VStack(alignment: .leading) {
        Section {
          List {
            ForEach(screens, id: \.self) { screen in
              NavigationLink(value: screen) {
                Text(screen.rawValue)
              }
            }
          }
        }
        
        Form {
          Toggle("Disable Idle Timer", isOn: $isIdleTimerDisabled)
        }
      }
      .navigationTitle("Clock It")
      .navigationDestination(for: NavigationDestinations.self) { screen in
        switch screen {
        case .Clock:
          HomeClockView(isIdleTimerDisabled: $isIdleTimerDisabled) {
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
