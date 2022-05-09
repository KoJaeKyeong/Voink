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
}
