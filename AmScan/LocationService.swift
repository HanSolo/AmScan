//
//  LocationService.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 11.11.22.
//

import CoreLocation
import Combine


class LocationSerivce: NSObject, CLLocationManagerDelegate, ObservableObject {

    var coordinatesPublisher          = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    
    
    private override init() {
        super.init()
        
        
        let events = Helper.getEvents()
        if !events.isEmpty {
            print(events.first?.name)
        }    
    }
    
    static let shared = LocationSerivce()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate        = self
        return manager
    }()
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinatesPublisher.send(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
}
