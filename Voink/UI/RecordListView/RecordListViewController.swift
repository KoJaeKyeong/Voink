//
//  RecordListViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit
import AVFAudio
import GoogleMaps
import CoreLocation
import SnapKit

final class RecordListViewController: UIViewController {
    
    let viewModel = RecordListViewModel()
    let player = AVAudioPlayer()
    let recordListView = RecordListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let coordinate = CLLocationManager().location?.coordinate else { return }
        viewModel.reverseGeocode(coordinate: coordinate, navigationItem: navigationItem, view: view)
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
    }
    
    private func configureLayout() {
        [recordListView].forEach { view.addSubview($0) }
        
        recordListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RecordListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        viewModel.reverseGeocode(coordinate: location.coordinate, navigationItem: navigationItem, view: view)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error in record listView: \(error.localizedDescription)")
    }
}
