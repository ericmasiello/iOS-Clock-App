//
//  WeatherManager.swift
//  Clock It
//
//  Created by Eric Masiello on 11/1/24.
//

import Combine
import CoreLocation

enum WeatherError: Error {
  case invalidResponse
  case networkError(Error)
  case invalidData
}

@MainActor
class WeatherManager: ObservableObject {
  @Published var weather: WeatherData?
  @Published var isLoading = true
  @Published var error: WeatherError?
  
  private var cachedCoordinates: (latitude: Double, longitude: Double)? = nil
    
  private var locationChangeCancellables = Set<AnyCancellable>()
  private let timerFrequency = 1.0 * 60 * 30 // fetch weather every 30 mins
  private var timerCancellable: AnyCancellable?
      
  init(locationManager: LocationManager) {
    // Subscribe to location updates
    locationManager.coordinatesPublisher
      .sink { [weak self] coordinates in
        debugPrint("[coordinates change] Fetching Weather Data from WeatherManager")
        
        self?.cachedCoordinates = (latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        Task {
          self?.weather = await WeatherClient.getWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
        self?.isLoading = false
      }
      .store(in: &locationChangeCancellables)
    
    self.timerCancellable = Timer.publish(every: timerFrequency, on: .main, in: .default)
      .autoconnect() // Automatically connect to start receiving updates
      .sink { [weak self] _ in
        Task {
          debugPrint("[timer] Fetching Weather Data from WeatherManager")
          guard let coordinates = self?.cachedCoordinates else { return }
          
          self?.weather = await WeatherClient.getWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
      }
  }
  
  deinit {
    // cancel all cancellables
    timerCancellable?.cancel()
    locationChangeCancellables.forEach { value in value.cancel() }
  }
}
