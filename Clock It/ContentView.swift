//
//  ContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var weatherManager = WeatherManager()
  @StateObject private var dateTimeManager = DateTimeManager()

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

  var body: some View {
    BounceView {
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
    .onAppear {
      UIApplication.shared.isIdleTimerDisabled = true
    }
    .edgesIgnoringSafeArea(.all)
    .statusBar(hidden: true)
    .preferredColorScheme(.dark)
  }
}

#Preview {
  ContentView()
}
