//
//  LocationManager.swift
//  Clock It
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
  private func debugCoordinates(coords: (Double, Double)?) -> (String, String) {
    guard let (lat, long) = coords else { return ("Unknown", "Unknown") }

    return (String(lat), String(long))
  }

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
    case .denied, .restricted:
      // Handle denied/restricted access
      print("Location access denied or restricted")
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    @unknown default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager error: \(error.localizedDescription)")
  }

  func requestAccess() {
    manager.requestWhenInUseAuthorization()
  }
}

// final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//  @Published var lastKnownLocation: CLLocationCoordinate2D?
//
//  @Published var lat: Float?
//  @Published var long: Float?
//
//  var manager = CLLocationManager()
//
//  func checkLocationAuthorization() {
//    manager.delegate = self
//    manager.startUpdatingLocation()
//
//    switch manager.authorizationStatus {
//    case .notDetermined: // The user choose allow or denny your app to get the location yet
//      manager.requestWhenInUseAuthorization()
//
//    case .restricted: // The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
//      print("Location restricted")
//
//    case .denied: // The user dennied your app to get location or disabled the services location or the phone is in airplane mode
//      print("Location denied")
//
//    case .authorizedAlways: // This authorization allows you to use all location services and receive location events whether or not your app is in use.
//      print("Location authorizedAlways")
//
//    case .authorizedWhenInUse: // This authorization allows you to use all location services and receive location events only when your app is in use
//      print("Location authorized when in use")
//
//      guard let location = manager.location else { return }
//
//      lat = Float(location.coordinate.latitude)
//      long = Float(location.coordinate.longitude)
//
//    @unknown default:
//      print("Location service disabled")
//    }
//  }
//
//  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { // Trigged every time authorization status changes
//    checkLocationAuthorization()
//  }
//
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    lastKnownLocation = locations.first?.coordinate
//  }
// }
