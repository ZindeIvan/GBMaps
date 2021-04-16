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
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    // MARK: - Private properties
    
    private var locationManager: CLLocationManager?
    
    private var coordinate : CLLocationCoordinate2D? {
        didSet {
            guard let coordinate = self.coordinate else { return }
            setLocation(coordinate: coordinate)
        }
    }
    
    private var route: GMSPolyline?
    
    private var routePath: GMSMutablePath?
    
    private let zoom : Float = 17.0
    
    private let pathColor : UIColor = .systemGreen
    
    private let pathWidth : Float = 5.0
    
    private let startingLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
    
    // MARK: - IBAction
    
    @IBAction private func startRecord(_ sender: Any) {
        configureRoute()
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction private func stopRecord(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        saveRouteInRealm()
    }
    
    @IBAction private func loadRecord(_ sender: Any) {
        loadRouteFromRealm()
        let bounds = GMSCoordinateBounds(path: routePath ?? GMSMutablePath())
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(zoom)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCamera()
        configureLocationManager()
    }
    
    // MARK: - Private methods
    
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
    
    private func configureRoute() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = pathColor
        route?.strokeWidth = CGFloat(pathWidth)
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    private func saveRouteInRealm() {
        try? RealmService.shared?.deleteAll()
        var points : [MapPoint] = []
        let  pathPointsCount = routePath?.count() ?? 0
        for i in 0...pathPointsCount - 1 {
            guard let pathCoordinate = routePath?.coordinate(at: UInt(i)) else { return }
            let point = MapPoint()
            point.id = Int(i)
            point.latitude = pathCoordinate.latitude
            point.longitude = pathCoordinate.longitude
            points.append(point)
        }
        try? RealmService.shared?.saveInRealm(objects: points)
    }
    
    private func loadRouteFromRealm() {
        routePath? = GMSMutablePath()
        let points : Results<MapPoint>? = RealmService.shared?.loadFromRealm()
        points?.forEach { routePath?.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)) }
        route?.path = routePath
    }

}

// MARK: - CLLocationManagerDelegate methods
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
