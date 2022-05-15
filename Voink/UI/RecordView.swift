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
    var totalSecond = Int()
    var timer:Timer?
    
    override func layoutSubviews() {
        configure()
        startTimer()
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        backgroundColor = .systemBackground
        
    }
    
    private func configureLayout() {
        [addressLabel, timeLabel, stopButton].forEach { addSubview($0) }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }

    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int

        if totalSecond == 0 {
            timer?.invalidate()
        }
        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = totalSecond / 60 % 60
        seconds = totalSecond % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
