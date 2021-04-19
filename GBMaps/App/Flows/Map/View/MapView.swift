//
//  MapView.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/12/21.
//

import UIKit
import GoogleMaps

class MapView : UIView {
    
    private(set) var exitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.backgroundColor = .systemGray6
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        return button
    }()
    
    private(set) var loadRouteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.backgroundColor = .systemGray6
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        return button
    }()
    
    private(set) var startRecordButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .focused)
        button.backgroundColor = .systemGray6
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        return button
    }()
    
    private(set) var stopRecordButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "stop"), for: .normal)
        button.setImage(UIImage(systemName: "stop.fill"), for: .focused)
        button.backgroundColor = .systemGray6
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        return button
    }()
    
    private(set) var buttonsStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemGray6
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) var mapView : GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.zoomGestures = true
        view.settings.scrollGestures = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        let safeArea = safeAreaLayoutGuide
        let topScreenSpacing : CGFloat = 10.0
        let buttonsWidth : CGFloat = 50.0
        let buttonsHeight : CGFloat = 40.0
        let stackHeight : CGFloat = 50.0
        backgroundColor = .systemGray6
        buttonsStack.addArrangedSubview(exitButton)
        buttonsStack.addArrangedSubview(loadRouteButton)
        buttonsStack.addArrangedSubview(stopRecordButton)
        buttonsStack.addArrangedSubview(startRecordButton)
        addSubview(buttonsStack)
        addSubview(mapView)
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: topScreenSpacing),
            buttonsStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: stackHeight),
            exitButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            exitButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            stopRecordButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            stopRecordButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            loadRouteButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            loadRouteButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            startRecordButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            startRecordButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            mapView.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: topScreenSpacing),
            mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
}
