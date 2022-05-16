//
//  MapViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/05.
//

import UIKit
import GoogleMaps
import CoreLocation

struct MapViewModel {
    let firebaseLogic = FirestoreLogic()
    
    var camera: GMSCameraPosition {
        let locationManager = CLLocationManager()
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else { return GMSCameraPosition() }
        return GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, addressLabel: UILabel, view: UIView) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(),
              let lines = address.lines else { return }

            addressLabel.text = lines.joined(separator: "\n")
            
            UIView.animate(withDuration: 0.25) {
                view.layoutIfNeeded()
            }
        }
    }
    
    func addMarkerOnGoogleMap(map: GMSMapView) {
        for recordGroup in firebaseLogic.recordGroups {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(recordGroup.latitude), longitude: CLLocationDegrees(recordGroup.longitude))
            marker.map = map
        }
    }
}
