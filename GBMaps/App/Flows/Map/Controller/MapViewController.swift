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
    
    private var markerImage : UIImage?
    
    private let markerImageKey : String = "markerImage"
    
    private let markerImageScale : Int = 85
    
    private var marker : GMSMarker?
    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadMarkerImage()
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
        mapView.takePhotoButton.addTarget(self,
                                          action: #selector(takePhotoButtonAction),
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
                self?.marker?.map = nil
                self?.mapView.mapView.animate(to: position)
                self?.marker = GMSMarker(position: location.coordinate)
                self?.marker?.map = self?.mapView.mapView
                self?.marker?.icon = self?.markerImage
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
    
    @objc private func takePhotoButtonAction(sender: UIButton!) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
}

extension MapViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = extractImage(from: info) else { return }
        
        let scaledImage = image.scalePreservingAspectRatio(
            targetSize: CGSize(width: markerImageScale, height: markerImageScale)
        )
        markerImage = scaledImage
        DispatchQueue.global(qos: .background).async {
            self.store(image: scaledImage,
                       forKey: self.markerImageKey)
        }
        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}

extension MapViewController {
    
    private func store(image: UIImage,
                       forKey key: String) {
        if let pngRepresentation = image.pngData() {
            
            UserDefaults.standard.set(pngRepresentation,
                                      forKey: key)
        }
    }
    
    private func loadMarkerImage() {
        DispatchQueue.global(qos: .background).async {
            if let savedImage = self.retrieveImage(forKey: self.markerImageKey) {
                DispatchQueue.main.async {
                    self.markerImage = savedImage
                }
            }
        }
    }
    
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
}
