//
//  ViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/6/21.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    private var locationManager: CLLocationManager?
    
    private var coordinate : CLLocationCoordinate2D? {
        didSet {
            guard let coordinate = self.coordinate else { return }
            setLocation(coordinate: coordinate)
//            setMarker(coordinate: coordinate)
        }
    }
    
    private var route: GMSPolyline?
    
    private var routePath: GMSMutablePath?
    
    private let zoom : Float = 17.0
    
    private let startingLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    @IBAction private func startRecord(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction private func stopRecord(_ sender: Any) {
    }
    
    @IBAction private func loadRecord(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCamera()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func configureCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: startingLocation.latitude,
                                              longitude: startingLocation.longitude,
                                              zoom: zoom)
        mapView.camera = camera
    }
    
    private func setLocation(coordinate: CLLocationCoordinate2D) {
        mapView.animate(toLocation: coordinate)
    }
    
    private func setMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = mapView
    }

}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        coordinate = location.coordinate
        routePath?.add(location.coordinate)
        route?.path = routePath
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
