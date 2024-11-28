//
//  ContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI
import SwiftData

enum NavigationDestinations: String, CaseIterable, Hashable {
  case Clock
  case Settings
}

struct ContentView: View {
  @Environment(\.modelContext) var modelContext
  @Query(sort: \UserConfiguration.wakeupTime) var userConfigurations: [UserConfiguration]
  
  // makes the Clock view the initial view
  @State private var navigationPath = NavigationPath([NavigationDestinations.Clock])

  var body: some View {
    NavigationStack(path: $navigationPath) {
      
      VStack(alignment: .leading) {
        Section {
          List {
            ForEach(NavigationDestinations.allCases, id: \.self) { screen in
              NavigationLink(value: screen) {
                Text(screen.rawValue)
              }
            }
          }
        }
      }
      .navigationTitle("Clock It")
      .navigationDestination(for: NavigationDestinations.self) { screen in
        
        if let config = userConfigurations.first {
          switch screen {
          case .Clock:
            HomeClockView(userConfiguration: config) {
              navigationPath.removeLast()
            }
          case .Settings:
            SettingsView(userConfiguration: config)
          }
        } else {
          Text("Sorry. An error occurred when accessing your configuration")
        }
        
        
      }
    }
    .edgesIgnoringSafeArea(.all)
    .statusBar(hidden: true)
    .preferredColorScheme(.dark)
    .onAppear {
      guard userConfigurations.count == 0 else {
        // only need 1 configuration defined
        return
      }
      
      
      // initialize with some defaults if not yet set
      let config = UserConfiguration(wakeupTime: UserConfiguration.createWakeTime(hour: 6, minutes: 15))
      modelContext.insert(config)
      navigationPath.append(NavigationDestinations.Settings)
    }
  }
}

#Preview {
  do {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: UserConfiguration.self, configurations: config)

    return ContentView()
      .modelContainer(container)
  } catch {
    return Text("Failed to create container \(error.localizedDescription)")
  }
}
