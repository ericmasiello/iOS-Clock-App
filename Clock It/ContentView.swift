//
//  ContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI

struct ContentView: View {
  
  private var size: CGFloat {
    let denominator = 5.0
    let fudge = (((denominator - 1) * 2) * -1) - 32
    let size = (UIScreen.main.bounds.width / denominator) + fudge
    return size
  }
  
  func emojiOption(now: Date) -> EmojiOption {
    let month = now.component(.month)

    if month == 10 {
      return .halloween
    } else if month == 11 {
      return .thanksgiving
    } else if month == 12 {
      return .snow
    }
    return .sparkles
  }

  var body: some View {
    WeatherDataView { weatherData in
      TimeView { now in
        ViewModeByDateView(date: now) { viewMode in
          BounceView {
            VStack(alignment: .leading, spacing: 0) {
              if viewMode == .active {
                EmojiView(option: emojiOption(now: now), size: size)
              }
              ClockView(size: size, viewMode: viewMode, now: now)
              HStack {
                Spacer()
                TemperatureView(temperatureF: weatherData?.current.temperature2m ?? 0.0)
              }
            }
            .fixedSize() // constrains it to widest element
            .opacity(viewMode == .dim ? 0.65 : 1)
          }
        }
      }
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
