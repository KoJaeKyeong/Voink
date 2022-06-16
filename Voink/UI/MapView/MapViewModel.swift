//
//  MapViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/05.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseFirestore

struct MapViewModel {
    let db = Firestore.firestore()
    
    var camera: GMSCameraPosition {
        let locationManager = CLLocationManager()
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else { return GMSCameraPosition() }
        print("latitude: \(latitude), longitude: \(longitude)")
        return GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, addressLabel: UILabel, view: UIView) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(),
                  let locality = address.locality,
                  let subLocality = address.subLocality else { return }
            
            addressLabel.text = "\(locality) \(subLocality)"
            
            UIView.animate(withDuration: 0.25) {
                view.layoutIfNeeded()
            }
        }
    }
    
    func addMarkerOnGoogleMap(map: GMSMapView) {
        db.collection("group").getDocuments() { (querySnapshot, error) in
            guard error == nil,
                  let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let decodedData = try JSONDecoder().decode(RecordGroup.self, from: jsonData)
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(decodedData.latitude), longitude: CLLocationDegrees(decodedData.longitude))
                    DispatchQueue.main.async {
                        marker.map = map
                    }
                } catch {
                    
                }
            }
        }
    }
}
