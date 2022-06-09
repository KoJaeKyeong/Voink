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
import AVFoundation

final class RecordView: UIView {
        
    private lazy var currentCountOfRecordLabel = UILabel()
    private lazy var addressLabel = UILabel()
    lazy var timeLabel = UILabel()
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
        
        currentCountOfRecordLabel.text = "Count Of Record: 2"
        currentCountOfRecordLabel.font = .systemFont(ofSize: 14)
        
        viewModel.reverseGeocode(coordinate: location.coordinate, addressLabel: addressLabel, view: self)
        addressLabel.textAlignment = .center
        addressLabel.font = .boldSystemFont(ofSize: 20)
        
        recordLabel.text = "Now Recording..."
        recordLabel.textColor = .systemRed
        
        timeLabel.font = .systemFont(ofSize: 18)
        
        stopButton.configuration = viewModel.stopButtonConfiguration
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.systemBackground, for: .normal)
        stopButton.setTitleColor(.systemBackground, for: .highlighted)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        [currentCountOfRecordLabel,addressLabel, timeLabel, recordLabel, stopButton].forEach { addSubview($0) }
        
        currentCountOfRecordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(currentCountOfRecordLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addressLabel.snp.bottom).offset(18)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(18)
        }
        
        stopButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    @objc func stopButtonTapped() {
        delegate?.stopButtonTapped()
    }
}
