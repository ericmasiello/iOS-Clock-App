//
//  LocationManager.swift
//  Clock It
//
//  Created by Eric Masiello on 11/8/24.
//


import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var lat: Double?
    @Published var long: Double?
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var coordinates: (latitude: Double, longitude: Double)? {
      
        didSet {
          
          // only update the subscriber if the values changed
          if oldValue?.latitude != coordinates?.latitude || oldValue?.longitude != coordinates?.longitude {
            // Only publish when we have valid coordinates
            if let coords = coordinates {
                coordinatesPublisher.send(coords)
            }
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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

//final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
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
//}
