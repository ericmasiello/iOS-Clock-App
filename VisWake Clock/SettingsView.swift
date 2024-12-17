//
//  SettingsView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/11/24.
//
import SwiftData
import SwiftUI

struct EventName: View {
  @Bindable var userConfiguration: UserConfiguration
  var event: CountdownEvent
  
  func formatEventDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.string(from: date)
  }
  
  var body: some View {
    Text("\(event.name) on \(formatEventDate(event.date))")
      .swipeActions {
        Button(role: .destructive, action: {
          // find the index of the item matching the event
          guard let index = userConfiguration.countdownEvents.firstIndex(of: event) else {
            return
          }
          
          userConfiguration.countdownEvents.remove(at: index)
          
        }) {
          Image(systemName: "trash")
        }
      }
  }
}

struct SettingsView: View {
  @Bindable var userConfiguration: UserConfiguration
  @State private var wakeupTime: Date
  @State private var isIdleTimerDisabled: Bool
//  @State private var showCountdownEventForm = false
  @State private var newCountdownEvent = CountdownEvent(date: Date(), name: "")

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
      Section {
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
        
        Toggle("Keep screen on", isOn: $isIdleTimerDisabled)
          .onChange(of: isIdleTimerDisabled) { _, newValue in
            if newValue == self.userConfiguration.isIdleTimerDisabled {
              return
            }
            self.userConfiguration.isIdleTimerDisabled = newValue
          }
      }
      
      // Explore converting to a popup sheet
      Section("New Event") {
        TextField("Event name", text: $newCountdownEvent.name)
        DatePicker(
          "Date",
          selection: $newCountdownEvent.date,
          displayedComponents: [.date]
        )
        Button("Add Event") {
          userConfiguration.countdownEvents.append(newCountdownEvent)
          newCountdownEvent = CountdownEvent(date: Date(), name: "")
        }
      }
      
      Section("Countdown Events") {
        List(userConfiguration.sortedCountdownEvents) { event in
          EventName(userConfiguration: userConfiguration, event: event)
        }
        if userConfiguration.sortedCountdownEvents.count == 0 {
          Text("No events added yet")
        }
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
