//
//  ViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/6/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

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
        locationManager?.stopUpdatingLocation()
        try? RealmService.shared?.deleteAll()
        var points : [MapPoint] = []
        for i in 0...Int(routePath?.count() ?? 0) {
            guard let pathCoordinate = routePath?.coordinate(at: UInt(i)) else { return }
            let point = MapPoint()
            point.id = "\(pathCoordinate.latitude)-\(pathCoordinate.longitude)"
            point.latitude = pathCoordinate.latitude
            point.longitude = pathCoordinate.longitude
            points.append(point)
        }
        try? RealmService.shared?.saveInRealm(objects: points)
    }
    
    @IBAction private func loadRecord(_ sender: Any) {
        routePath? = GMSMutablePath()
        let points : Results<MapPoint>? = RealmService.shared?.loadFromRealm()
        points?.forEach({ (point) in
            let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            routePath?.add(coordinate)
        })
        
        route?.path = routePath
        let bounds = GMSCoordinateBounds(path: routePath ?? GMSMutablePath())
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
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
