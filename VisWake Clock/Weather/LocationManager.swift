//
//  LocationManager.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/8/24.
//

/***

 39.15729336315888, -77.05492181674678
 39.15729336315888, -77.05492181674678

 */

import Combine
import CoreLocation
import Foundation
import Sentry

struct GPSCoordinateNormalizer {
  /// Normalizes GPS coordinates and provides comparison with a minimum distance threshold
  struct NormalizedCoordinate {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    /// Calculates the distance between two normalized coordinates
    /// - Parameter other: Another normalized coordinate to compare
    /// - Returns: Distance in miles between the two coordinates
    func distance(to other: NormalizedCoordinate) -> CLLocationDistance {
      let coordinate1 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let coordinate2 = CLLocationCoordinate2D(latitude: other.latitude, longitude: other.longitude)

      let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
      let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)

      // Converts distance to miles (1 mile = 1609.344 meters)
      return location1.distance(from: location2) / 1609.344  // Convert meters to miles
    }

    /// Checks if the coordinate is significantly different from another coordinate
    /// - Parameters:
    ///   - other: Another normalized coordinate to compare
    ///   - threshold: Minimum distance in miles to be considered different (default is 5 miles)
    /// - Returns: Boolean indicating if the coordinates are significantly different
    func isDifferent(from other: NormalizedCoordinate, milesThreshold: CLLocationDistance = 5.0)
      -> Bool
    {
      return distance(to: other) >= milesThreshold
    }
  }

  /// Normalizes a raw coordinate
  /// - Parameters:
  ///   - latitude: Latitude coordinate
  ///   - longitude: Longitude coordinate
  /// - Returns: A normalized coordinate ready for comparison
  static func normalize(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    -> NormalizedCoordinate
  {
    return NormalizedCoordinate(latitude: latitude, longitude: longitude)
  }
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  private let manager = CLLocationManager()

  @Published var lat: Double?
  @Published var long: Double?
  @Published var locationStatus: CLAuthorizationStatus?
  @Published var coordinates: (latitude: Double, longitude: Double)? {
    didSet {
      guard let newCoords = coordinates else {
        return
      }

      guard let previousCoords = oldValue else {
        return coordinatesPublisher.send(newCoords)
      }

      let normalizedOldCoords = GPSCoordinateNormalizer.normalize(
        latitude: previousCoords.latitude, longitude: previousCoords.longitude)
      let normalizednewCoords = GPSCoordinateNormalizer.normalize(
        latitude: newCoords.latitude, longitude: newCoords.longitude)

      // only update when distance is 5 miles
      if normalizedOldCoords.isDifferent(from: normalizednewCoords, milesThreshold: 5) {
        coordinatesPublisher.send(newCoords)
      }
    }
  }

  // Publisher for coordinates that other objects can subscribe to
  let coordinatesPublisher = PassthroughSubject<(latitude: Double, longitude: Double), Never>()

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }

    lat = location.coordinate.latitude
    long = location.coordinate.longitude

    // Update coordinates tuple which will trigger the publisher
    if let latitude = lat, let longitude = long {
      coordinates = (latitude: latitude, longitude: longitude)
    }
  }

  func locationManager(
    _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
  ) {
    locationStatus = status

    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.startUpdatingLocation()
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    SentrySDK.capture(error: error)
  }

  func requestAccess() {
    manager.requestWhenInUseAuthorization()
  }
}
