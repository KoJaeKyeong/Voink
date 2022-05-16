//
//  RecordListCell.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/15.
//

import UIKit
import SnapKit

final class RecordListCell: UITableViewCell {
    
    let identifier = "recordListCell"
    var delegate: RecordListViewController?
    
    lazy var playButton = UIButton()
    lazy var slider = UISlider()
    lazy var currentTimeLabel = UILabel()
    lazy var totalTimeLabel = UILabel()
    
    override func layoutSubviews() {
        configure()
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        let config = UIImage.SymbolConfiguration(pointSize: 35)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        
        currentTimeLabel.font = .systemFont(ofSize: 13)
        totalTimeLabel.font = .systemFont(ofSize: 13)
    }
    
    private func configureLayout() {
        [playButton, slider, currentTimeLabel, totalTimeLabel].forEach { contentView.addSubview($0) }
        
        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(25)
        }
        
        currentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(slider)
            make.top.equalTo(slider.snp.bottom)
        }
        
        totalTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(slider)
            make.top.equalTo(slider.snp.bottom)
        }
    }
}
