//
//  RecordViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/27.
//

import UIKit

struct RecordViewModel {
    var configuration: UIButton.Configuration {
        var configuration = UIButton.Configuration.tinted()
        var background = UIButton.Configuration.tinted().background
        background.backgroundColor = .systemRed
        background.cornerRadius = 10
        configuration.background = background
        return configuration
    }
}
