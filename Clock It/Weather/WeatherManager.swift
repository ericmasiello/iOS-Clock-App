//
//  WeatherManager.swift
//  Clock It
//
//  Created by Eric Masiello on 11/1/24.
//

import Combine
import Foundation

class WeatherManager: ObservableObject {
  // A published property that will update every second
  @Published var weather: WeatherData?
  
  private var cancellable: AnyCancellable?

  func fetch() {
    
    // Use Timer.publish to create a timer that emits every 1 hour
    self.cancellable = Timer.publish(every: 1.0 * 60 * 60, on: .main, in: .default)
      .autoconnect() // Automatically connect to start receiving updates
      .sink { [weak self] _ in
        Task {
          print("Fetching Weather Data from WeatherManager - timer")
          self?.weather = await WeatherClient.getWeather()
        }
      }
    
    Task {
      print("Fetching Weather Data from WeatherManager - initial")
      weather = await WeatherClient.getWeather()
    }
  }

  init() {
    fetch()
  }

  deinit {
    cancellable?.cancel()
  }
}
