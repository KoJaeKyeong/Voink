//
//  RecordListHeaderCell.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/15.
//

import UIKit
import SnapKit

class RecordListHeaderCell: UITableViewHeaderFooterView {
    
    let identifier = "recordListHeaderCell"
    
    lazy var titleLabel = UITextField()
    lazy var contentLabel = UITextView()
    lazy var countOfRecordLabel = UILabel()
    
    override func layoutSubviews() {
        configure()
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        
    }
    
    private func configureLayout() {
        [titleLabel, contentLabel, countOfRecordLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
        
        countOfRecordLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(15)
            make.leading.equalTo(titleLabel.snp.trailing)
        }
    }
}
