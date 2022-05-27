//
//  RecordView.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/11.
//

import UIKit
import SnapKit
import GoogleMaps
import CoreLocation

final class RecordView: UIView {
        
    private lazy var addressLabel = UILabel()
    private lazy var timeLabel = UILabel()
    private lazy var recordLabel = UILabel()
    private lazy var stopButton = UIButton()
    
    private let locationManager = CLLocationManager()
    private let viewModel = RecordViewModel()
    var delegate: RecordViewDelegate?
    
    override func layoutSubviews() {
        configure()
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        guard let location = locationManager.location else { return }
        backgroundColor = .systemBackground
        
        viewModel.reverseGeocode(coordinate: location.coordinate, addressLabel: addressLabel, view: self)
        addressLabel.textAlignment = .center
        addressLabel.font = .boldSystemFont(ofSize: 20)
        
        recordLabel.text = "Now Recording..."
        recordLabel.textColor = .systemRed
        
        timeLabel.text = "00:00.00"
        timeLabel.font = .systemFont(ofSize: 18)
        
        stopButton.configuration = viewModel.stopButtonConfiguration
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.systemBackground, for: .normal)
        stopButton.setTitleColor(.systemBackground, for: .highlighted)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        [addressLabel, timeLabel, recordLabel, stopButton].forEach { addSubview($0) }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-25)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        
        stopButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    @objc func stopButtonTapped() {
        delegate?.stopButtonTapped()
    }
}
