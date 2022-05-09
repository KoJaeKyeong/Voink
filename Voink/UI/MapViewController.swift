//
//  MapViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit
import SnapKit
import GoogleMaps
import CoreLocation

final class MapViewController: UIViewController {

    private lazy var addressLabel = UILabel()
    private lazy var mapView = GMSMapView()
    
    private let locationManager = CLLocationManager()
    
    private let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureLocationManager()
        configureAttribute()
        configureLayout()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func configureAttribute() {
        addressLabel.textAlignment = .left
    }
    
    private func configureLayout() {
        [addressLabel, mapView].forEach { view.addSubview($0) }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse,
              let coordinate = manager.location?.coordinate else { return }
        
        manager.requestLocation()
        viewModel.reverseGeocode(coordinate: coordinate, addressLabel: addressLabel, view: view)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15)
        viewModel.reverseGeocode(coordinate: location.coordinate, addressLabel: addressLabel, view: view)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
