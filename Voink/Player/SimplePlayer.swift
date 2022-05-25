//
//  SimplePlayer.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/20.
//

import AVFoundation

class SimplePlayer {
    static let shared = SimplePlayer()
    
    private let player = AVPlayer()
    
    var currentTime: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    var totalDurationTime: Double {
        return player.currentItem?.duration.seconds ?? 0
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    var currentItem: AVPlayerItem? {
        return player.currentItem
    }
    
    init() { }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
    }
    
    func seek(to time:CMTime) {
        player.seek(to: time)
    }
    
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) -> Any {
        return player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
    
    func removeTimeObserver(observer: Any) {
        player.removeTimeObserver(observer)
    }
}

