//
//  SettingsView.swift
//  Clock It
//
//  Created by Eric Masiello on 11/11/24.
//
import SwiftUI

// Example SwiftUI view showing weather data
struct WeatherView: View {
  @StateObject private var locationManager: LocationManager
  @StateObject private var weatherManager: WeatherManager
    
  init() {
    let lm = LocationManager();
    _locationManager = StateObject(wrappedValue: lm)
    _weatherManager = StateObject(wrappedValue: WeatherManager(locationManager: lm))
  }
    
  var body: some View {
    VStack {
      Button("Access Location") {
        _locationManager.wrappedValue.requestAccess()
      }
      if weatherManager.isLoading {
        ProgressView("Fetching weather...")
      } else if let weather = weatherManager.weather {
        // Weather data view
        VStack(spacing: 20) {
                    
          Text(String(weather.current.temperature2m))
            .font(.title2)
        }
      } else if let error = weatherManager.error {
        // Error view
        VStack {
          Image(systemName: "exclamationmark.triangle")
            .font(.largeTitle)
            .foregroundColor(.red)
                    
          Text(errorMessage(for: error))
            .multilineTextAlignment(.center)
            .padding()
                    
        }
      }
    }
    .padding()
  }
    
  private func errorMessage(for error: WeatherError) -> String {
    switch error {
    case .invalidResponse:
      return "Unable to fetch weather data.\nPlease try again later."
    case .networkError(let error):
      return "Network error: \(error.localizedDescription)"
    case .invalidData:
      return "Unable to process weather data.\nPlease try again later."
    }
  }
}

struct SettingsView: View {
  var body: some View {
    WeatherView()
  }
}

#Preview {
  SettingsView()
}
