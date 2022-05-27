//
//  RecoedViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit
import SnapKit

final class RecordViewController: UIViewController {
    
    private lazy var recordView = RecordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureAttribute()
        configureLayout()
    }
    
    private func configureAttribute() {
        view.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        recordView.delegate = self
    }
    
    private func configureLayout() {
        view.addSubview(recordView)
        
        recordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(230)
        }
    }
}

// MARK: RecordViewDelegate 구현

extension RecordViewController: RecordViewDelegate {
    func stopButtonTapped() {
        presentingViewController?.dismiss(animated: true)
    }
}
