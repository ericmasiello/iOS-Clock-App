//
//  HomeClockView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/11/24.
//

import SwiftUI

typealias HandleBackTapped = () -> Void

struct HomeClockView: View {
  @Bindable var userConfiguration: UserConfiguration
  @StateObject private var locationManager: LocationManager
  @StateObject private var weatherManager: WeatherManager
  @StateObject private var dateTimeManager: DateTimeManager

  var handleBackTapped: HandleBackTapped

  init(userConfiguration: UserConfiguration, handleBackTapped: @escaping HandleBackTapped) {
    self.userConfiguration = userConfiguration
    let lm = LocationManager()
    _locationManager = StateObject(wrappedValue: lm)
    _weatherManager = StateObject(wrappedValue: WeatherManager(locationManager: lm))

    _dateTimeManager = StateObject(wrappedValue: DateTimeManager())
    self.handleBackTapped = handleBackTapped
  }

  func formatTime(_ date: Date?) -> String {
    guard let date = date else {
      return "Unknown"
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"

    return formatter.string(from: date)
  }

  private var size: CGFloat {
    let denominator = 5.0
    let fudge = (((denominator - 1) * 2) * -1) - 32
    let size = (UIScreen.main.bounds.width / denominator) + fudge
    return size
  }

  private var emojiOption: EmojiOption {
    EmojiManager.option(by: dateTimeManager.now)
  }

  private var viewMode: ViewMode {

    guard let wakeupTime = userConfiguration.wakeupTime else {
      return .dim
    }

    return ViewModeManager.mode(
      by: dateTimeManager.now, wakeup: wakeupTime, wakeupDuration: userConfiguration.wakeupDuration)
  }

  private var currentTime: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"

    return dateFormatter.string(from: Date.now)
  }

  var body: some View {
    BounceView {
      Button(action: {
        handleBackTapped()
      }) {
        VStack(alignment: .leading, spacing: 0) {
          if viewMode == .active {
            EmojiView(option: emojiOption, size: size)
          }
          DaysUntilView(events: userConfiguration.countdownEvents).padding(.bottom, 8).font(.headline)
          ClockView(size: size, viewMode: viewMode, now: dateTimeManager.now)
          HStack {
            Text("Wake up time \(formatTime(userConfiguration.wakeupTime))")
            Spacer()
            TemperatureView(temperatureF: weatherManager.weather?.current.temperature2m ?? 0.0)
              .opacity(weatherManager.weather?.current.temperature2m == nil ? 0.0 : 1.0)
          }
        }
        .fixedSize()  // constrains it to widest element
        .opacity(viewMode == .dim ? 0.65 : 1)
      }
    }
    .accessibilityLabel(Text("Current time is \(currentTime). Tap to return the main view"))
    .buttonStyle(.plain)
    .onAppear {
      UIApplication.shared.isIdleTimerDisabled = self.userConfiguration.isIdleTimerDisabled
    }
    .navigationBarBackButtonHidden()
  }
}
