//
//  MapViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/12/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var mapView: MapView = {
        return MapView()
    }()
    
    private lazy var router : MapRouter = {
        return MapRouter(controller: self)
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var locationManager = LocationManager.instance
    
    private let disposeBag = DisposeBag()
    
    private var route: GMSPolyline?
    
    private var routePath: GMSMutablePath?
    
    private let zoom : Float = 17.0
    
    private let pathColor : UIColor = .magenta
    
    private let pathWidth : Float = 5.0
    
    private let startingLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCamera()
        configureLocationManager()
    }
    
    override func loadView() {
        view = mapView
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        mapView.loadRouteButton.addTarget(self,
                                          action: #selector(loadRouteButtonAction),
                                          for: .touchUpInside)
        mapView.startRecordButton.addTarget(self,
                                            action: #selector(startRecordButtonAction),
                                            for: .touchUpInside)
        mapView.stopRecordButton.addTarget(self,
                                           action: #selector(stopRecordButtonAction),
                                           for: .touchUpInside)
        mapView.exitButton.addTarget(self,
                                           action: #selector(exitButtonAction),
                                           for: .touchUpInside)
    }
    
    private func configureLocationManager() {
        locationManager
            .location
            .subscribe(onNext: { [weak self] (location) in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.mapView.animate(to: position)
            }).disposed(by: disposeBag)
    }
    
    private func configureCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: startingLocation.latitude,
                                              longitude: startingLocation.longitude,
                                              zoom: zoom)
        mapView.mapView.camera = camera
    }
    
    private func setLocation(coordinate: CLLocationCoordinate2D) {
        mapView.mapView.animate(toLocation: coordinate)
    }
    
    private func configureRoute() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = pathColor
        route?.strokeWidth = CGFloat(pathWidth)
        routePath = GMSMutablePath()
        route?.map = mapView.mapView
    }
    
    private func saveRouteInRealm() {
        try? RealmService.shared?.deleteAll(object: MapPoint())
        var points : [MapPoint] = []
        let  pathPointsCount = routePath?.count() ?? 0
        guard pathPointsCount > 0 else { return }
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

    @objc private func loadRouteButtonAction(sender: UIButton!) {
        loadRouteFromRealm()
        let bounds = GMSCoordinateBounds(path: routePath ?? GMSMutablePath())
        mapView.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(zoom)))
    }
    
    @objc private func startRecordButtonAction(sender: UIButton!) {
        configureRoute()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func stopRecordButtonAction(sender: UIButton!) {
        locationManager.stopUpdatingLocation()
        saveRouteInRealm()
    }
    
    @objc private func exitButtonAction(sender: UIButton!) {
        locationManager.stopUpdatingLocation()
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLogin()
    }
}
