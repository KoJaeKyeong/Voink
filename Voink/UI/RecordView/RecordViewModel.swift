//
//  RecordViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/27.
//

import UIKit
import GoogleMaps
import CoreLocation

struct RecordViewModel {
    var stopButtonConfiguration: UIButton.Configuration {
        var configuration = UIButton.Configuration.tinted()
        var background = UIButton.Configuration.tinted().background
        background.backgroundColor = .systemRed
        background.cornerRadius = 10
        configuration.background = background
        return configuration
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
}
