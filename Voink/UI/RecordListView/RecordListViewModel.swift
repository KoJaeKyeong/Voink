//
//  RecordListViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/15.
//

import UIKit
import CoreLocation
import GoogleMaps

struct RecordListViewModel {
    let firebaseLogic = FirestoreLogic()
    let player = SimplePlayer()
    
    var numberOfSections: Int {
        return firebaseLogic.recordGroups.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return firebaseLogic.recordGroups[section].countOfRecord
    }
    
    func title(section: Int) -> String {
        return firebaseLogic.recordGroups[section].title
    }
    
    func countOfRecord(section: Int) -> String {
        return "\(firebaseLogic.recordGroups[section].countOfRecord)"
    }
    
    func content(section: Int) -> String {
        return firebaseLogic.recordGroups[section].content
    }
    
    var heightForHeaderInSection: CGFloat {
        return 120
    }
    
    var heightForRowAt: CGFloat {
        return 70
    }
    
    func itemURL(section: Int, row: Int) -> URL? {
        return URL(string: firebaseLogic.recordGroups[section].recordList[row].path)
    }
    
    func totalTime(section: Int, row: Int) -> String {
        let timeInterval = firebaseLogic.recordGroups[section].recordList[row].playtime
        let minute = (timeInterval / 1000) / 60
        let second = (timeInterval / 1000) % 60
        return String(format: "%0.2d:%0.2d", minute, second)
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, navigationItem: UINavigationItem, view: UIView) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(),
                  let locality = address.locality,
                  let subLocality = address.subLocality else { return }
            
            navigationItem.title = "\(locality) \(subLocality)"

            UIView.animate(withDuration: 0.25) {
                view.layoutIfNeeded()
            }
        }
        
    }
    
    func secondToString(sec: Double) -> String {
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
}
