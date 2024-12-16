//
//  ClockView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

import SwiftUI

struct ClockView: View {
  var size: CGFloat = 10
  var viewMode: ViewMode = .dim
  var now: Date

  private var hour: (String, String, Color?) {
    let hour = now.component(.hour)
    let normalizedHour = hour > 12 ? hour - 12 : hour

    let color: Color? =
      switch viewMode {
      case .active:
        .yellow.opacity(0.8)
      case .dim:
        nil
      }

    return (String(normalizedHour / 10), String(normalizedHour % 10), color)
  }

  private var minutes: (String, String) {
    (String(now.component(.minute) / 10), String(now.component(.minute) % 10))
  }

  var body: some View {
    Group {
      HStack(spacing: 10) {
        FlipClockNumberView(value: hour.0, size: size, color: hour.2)
        FlipClockNumberView(value: hour.1, size: size, color: hour.2)
        FlipClockNumberView(value: ":", size: size)
        FlipClockNumberView(value: minutes.0, size: size)
        FlipClockNumberView(value: minutes.1, size: size)
      }
    }
  }
}

#Preview {
  VStack {
    ClockView(size: 100.0, now: Date())
    ClockView(size: 100.0, viewMode: .active, now: Date())
  }
  .padding()
  .preferredColorScheme(.dark)
}
