//
//  RecoedViewController.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/03.
//

import UIKit
import SnapKit
import AVFoundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

final class RecordViewController: UIViewController {
    
    private lazy var recordView = RecordView()
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        checkRecordPermission()
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
            make.height.equalTo(220)
        }
    }
    
    private func checkRecordPermission() -> Bool {
        var isAudioRecordingGranted = false
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            isAudioRecordingGranted = true
            break
        case .denied:
            isAudioRecordingGranted = false
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                if allowed {
                    isAudioRecordingGranted = true
                } else {
                    isAudioRecordingGranted = false
                }
            }
            break
        default:
            break
        }
        
        return isAudioRecordingGranted
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
    return filePath
    }
}

// MARK: AVAudioRecorderDelegate 구현
extension RecordViewController: AVAudioRecorderDelegate {
    
}

// MARK: RecordViewDelegate 구현
extension RecordViewController: RecordViewDelegate {
    func stopButtonTapped() {
        presentingViewController?.dismiss(animated: true)
    }
}
