//
//  Record.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/09.
//

import Foundation

struct RecordGroup {
    let id: Int
    let category: String
    let clientId: String
    let content: String
    let countOfRecord: Int
    let countOfSaved: Int
    let deleted: Bool
    let displayLocation: String
    let latitude: Float
    let longitude: Float
    let pathVisible: Float
    let time: Int
    let title: String
    let totalLength: Int
    let type: String
    let visibleType: String
    let recordList: [Record]
}

struct Record {
    let location: Location
    let path: String
    let playtime: Int
    let thumbnail: String
    let title: String
}

struct Location {
    let latitude: Float
    let longitude: Float
}
