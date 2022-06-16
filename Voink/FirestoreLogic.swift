//
//  Firestore.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/05/09.
//

import Foundation
import FirebaseFirestore

final class FirestoreLogic {
    let db = Firestore.firestore()
    var recordGroups = [RecordGroup]()
    
    func fetchRecordGroupsWithEscaping(completion: @escaping ([RecordGroup]) -> Void) {
        db.collection("group").getDocuments() { [weak self] (querySnapshot, error) in
            guard error == nil,
                  let self = self,
                  let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let decodedData = try JSONDecoder().decode(RecordGroup.self, from: jsonData)
                    self.recordGroups.append(decodedData)
                } catch {
                    
                }
            }
            
            completion(self.recordGroups)
        }
    }
    
//    func fetchRecordGroups() async throws -> [RecordGroup] {
//        var recordGroup = [RecordGroup]()
//        let querySnapshot = try await db.collection("group").getDocuments()
//        for documents in querySnapshot.documents {
//            let jsonData = try JSONSerialization.data(withJSONObject: documents.data(), options: [])
//            let decodedData = try JSONDecoder().decode(RecordGroup.self, from: jsonData)
//            recordGroup.append(decodedData)
//        }
//        return recordGroup
//    }
    
    init() {
//        Task.init {
//            do {
//                let recordGroups = try await fetchRecordGroups()
//                print("record: \(recordGroups)")
//            } catch {
//
//            }
//        }
        fetchRecordGroupsWithEscaping { [weak self] data in
            guard let self = self else { return }
            self.recordGroups = data
        }
    }
}
