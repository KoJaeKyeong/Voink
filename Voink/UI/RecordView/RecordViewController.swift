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
    let viewModel = RecordViewModel()
    let db = Firestore.firestore()
    
    var isAudioRecordingGranted = false
    var audioRecorder: AVAudioRecorder?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startRecording()
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
    
    private func startRecording() {
        setupRecorder(isAudioRecordingGranted: checkRecordPermission())
        audioRecorder?.record()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioMeter(timer:)), userInfo: nil, repeats: true)
    }
    
    private func checkRecordPermission() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            isAudioRecordingGranted = true
            break
        case .denied:
            isAudioRecordingGranted = false
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { [self] allowed in
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
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    private func setupRecorder(isAudioRecordingGranted: Bool) {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.record)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.isMeteringEnabled = true
                audioRecorder?.prepareToRecord()
            }
            catch let error {
                print("record setting error: \(error.localizedDescription)")
            }
        } else {
            
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        guard let audioRecorder = audioRecorder else { return }
        if audioRecorder.isRecording {
            print("currentTime: \(audioRecorder.currentTime)")
            let min = Int((audioRecorder.currentTime) / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            recordView.timeLabel.text = String(format: "%02d:%02d", min, sec)
            audioRecorder.updateMeters()
        }
    }
}

// MARK: AVAudioRecorderDelegate 구현
extension RecordViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            viewModel.showAlert(title: "Failed to record", message: nil, viewController: self)
        }
    }
}

// MARK: RecordViewDelegate 구현
extension RecordViewController: RecordViewDelegate {
    func stopButtonTapped() {
        print("finished record!!!!!!!!!")
        audioRecorder?.stop()
        audioRecorder = nil
        timer?.invalidate()
        presentingViewController?.dismiss(animated: true)
    }
}
