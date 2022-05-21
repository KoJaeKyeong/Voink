//
//  Extension+AVPlayer.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/20.
//
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
