//
//  WeatherView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

import SwiftUI

struct TemperatureView: View {
  var temperatureF: Float

  var body: some View {
    Group {
      Text("\(Int(temperatureF.rounded()))")
        .font(.largeTitle)
        + Text("℉")
        .font(.title3)
    }
    .monospaced()
  }

}

#Preview {
  TemperatureView(temperatureF: 88.2345)
    .padding()
    .preferredColorScheme(.dark)
}
