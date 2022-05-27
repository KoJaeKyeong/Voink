//
//  RecordView.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/11.
//

import UIKit
import SnapKit

final class RecordView: UIView {
        
    private lazy var addressLabel = UILabel()
    private lazy var timeLabel = UILabel()
    private lazy var stopButton = UIButton()
    
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
        backgroundColor = .systemBackground
        
        stopButton.configuration = viewModel.configuration
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.systemBackground, for: .normal)
        stopButton.setTitleColor(.systemBackground, for: .highlighted)

        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        [addressLabel, timeLabel, stopButton].forEach { addSubview($0) }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        stopButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func stopButtonTapped() {
        delegate?.stopButtonTapped()
    }
}
