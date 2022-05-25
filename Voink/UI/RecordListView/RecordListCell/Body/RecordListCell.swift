//
//  RecordListCell.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/15.
//

import UIKit
import SnapKit
import AVFoundation

final class RecordListCell: UITableViewCell {
    
    let identifier = "recordListCell"
    
    lazy var playButton = UIButton()
    lazy var slider = UISlider()
    lazy var currentTimeLabel = UILabel()
    lazy var totalTimeLabel = UILabel()
    
    let viewModel = RecordListCellViewModel()
    var player: SimplePlayer?
    var delegate: RecordListCellDelegate?
    
    var isSeeking = false
    var timeObserver: Any?
    
    override func layoutSubviews() {
        configure()
    }
    
    override func prepareForReuse() {
        guard let player = player else { return }
        player.pause()
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 100))
        slider.value = 0.0
        self.timeObserver = nil
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        let config = UIImage.SymbolConfiguration(pointSize: 35)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        slider.addTarget(self, action: #selector(sliderEditingDidBegin), for: .editingDidBegin)
        slider.addTarget(self, action: #selector(sliderEditingDidEnd), for: .editingDidEnd)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        currentTimeLabel.font = .systemFont(ofSize: 13)
        currentTimeLabel.text = "00:00"
        totalTimeLabel.font = .systemFont(ofSize: 13)
    }
    
    private func configureLayout() {
        [playButton, slider, currentTimeLabel, totalTimeLabel].forEach { contentView.addSubview($0) }
        
        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
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
    
    @objc func playButtonTapped() {
        guard let delegate = delegate else { return }
        delegate.playButtonTapped(cell: self)
    }
    
    @objc func sliderEditingDidBegin() {
        isSeeking = true
    }
    
    @objc func sliderEditingDidEnd() {
        isSeeking = false
    }
    
    @objc func sliderValueChanged() {
        
    }
}
