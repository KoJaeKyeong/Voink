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
        viewModel.addMarkerOnGoogleMap(map: mapView)
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else { return }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
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
        mapView.camera = viewModel.camera
        
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
        
        viewModel.reverseGeocode(coordinate: location.coordinate, addressLabel: addressLabel, view: view)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
