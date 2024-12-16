//
//  WeatherDataView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//
import SwiftUI

struct WeatherDataView<Content: View>: View {
  @ViewBuilder let content: (WeatherData?) -> Content
  @State private var weatherData: WeatherData?

  var body: some View {
    content(weatherData)
      .onAppear {
        Task {
          let data = await WeatherClient.getWeather(latitude: 22.22, longitude: 22.22)

          guard let data = data else {
            return
          }
          weatherData = data
        }
      }
  }
}

#Preview {
  WeatherDataView { weatherData in
    Text("\(weatherData?.current.temperature2m ?? 0.0)").font(.largeTitle)
  }
}
