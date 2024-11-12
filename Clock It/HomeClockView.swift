//
//  HomeClockView.swift
//  Clock It
//
//  Created by Eric Masiello on 11/11/24.
//

import SwiftUI

typealias HandleBackTapped = () -> Void

struct HomeClockView: View {
  @StateObject private var locationManager: LocationManager
  @StateObject private var weatherManager: WeatherManager
  @StateObject private var dateTimeManager: DateTimeManager
  var handleBackTapped: HandleBackTapped
  
  init(handleBackTapped: @escaping HandleBackTapped) {
    let lm = LocationManager()
    _locationManager = StateObject(wrappedValue: lm)
    _weatherManager = StateObject(wrappedValue: WeatherManager(locationManager: lm))
    
    _dateTimeManager = StateObject(wrappedValue: DateTimeManager())
    self.handleBackTapped = handleBackTapped
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
    ViewModeManager.mode(by: dateTimeManager.now)
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
          ClockView(size: size, viewMode: viewMode, now: dateTimeManager.now)
          HStack {
            Spacer()
            TemperatureView(temperatureF: weatherManager.weather?.current.temperature2m ?? 0.0)
              .opacity(weatherManager.weather?.current.temperature2m == nil ? 0.0 : 1.0)
          }
        }
        .fixedSize() // constrains it to widest element
        .opacity(viewMode == .dim ? 0.65 : 1)
      }
    }
    .accessibilityLabel(Text("Current time is \(currentTime). Tap to return the main view"))
    .buttonStyle(.plain)
    .onAppear {
      UIApplication.shared.isIdleTimerDisabled = true
    }
    .navigationBarBackButtonHidden()
  }
}
