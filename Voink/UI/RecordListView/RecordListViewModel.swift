//
//  RecordListViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/15.
//

import Foundation

struct RecordListViewModel {
    let firebaseLogic = FirestoreLogic()
    
    var numberOfSections: Int {
        return firebaseLogic.recordGroups.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return firebaseLogic.recordGroups[section].countOfRecord
    }
}
