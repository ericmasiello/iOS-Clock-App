//
//  SettingsView.swift
//  Clock It
//
//  Created by Eric Masiello on 11/11/24.
//
import SwiftData
import SwiftUI

struct SettingsView: View {
  @Bindable var userConfiguration: UserConfiguration
  @State private var wakeupTime: Date
  @State private var isIdleTimerDisabled: Bool

  init(userConfiguration: UserConfiguration) {
    self.userConfiguration = userConfiguration
    self.wakeupTime =
      userConfiguration.wakeupTime ?? UserConfiguration.createWakeTime(hour: 12, minutes: 0)
    self.isIdleTimerDisabled = userConfiguration.isIdleTimerDisabled
  }

  func formatTime(_ date: Date?) -> String {
    guard let date = date else {
      return "Unknown"
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }

  var body: some View {
    Form {
      DatePicker(
        "Wake up time",
        selection: $wakeupTime,
        displayedComponents: [.hourAndMinute]
      )
      .onChange(of: wakeupTime) { _, newValue in

        if newValue == self.userConfiguration.wakeupTime {
          return
        }

        self.userConfiguration.wakeupTime = newValue
      }

      Toggle("Disable Idle Timer", isOn: $isIdleTimerDisabled)
        .onChange(of: isIdleTimerDisabled) { _, newValue in
          if newValue == self.userConfiguration.isIdleTimerDisabled {
            return
          }
          self.userConfiguration.isIdleTimerDisabled = newValue
        }
    }
    .navigationTitle("Edit Settings")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: UserConfiguration.self, configurations: config)
  let userConfig = UserConfiguration(
    wakeupTime: UserConfiguration.createWakeTime(hour: 6, minutes: 15))

  NavigationStack {
    SettingsView(userConfiguration: userConfig).modelContainer(container)
  }
}
