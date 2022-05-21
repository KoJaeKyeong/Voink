//
//  RecordListCellViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/21.
//

import Foundation

struct RecordListCellViewModel {
    func secondToString(sec: Double) -> String {
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
}
