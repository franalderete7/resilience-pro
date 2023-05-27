//
//  WorkoutsClass.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI
import CloudKit
import Combine

struct CloudKitWorkoutModelNames {
    static let name = "name"
}

struct WorkoutModel: Hashable, CloudKitableProtocol {
    let name: String
    let description: String
    let image: CKAsset
    let difficulty: String
    var blocks: [CKRecord.Reference] = []
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard
            let name = record[CloudKitProgramModelNames.name] as? String,
            let imageAsset = record["image"] as? CKAsset,
            let description = record["description"] as? String,
            let difficulty = record["difficulty"] as? String,
            let blocks = record["blocks"] as? [CKRecord.Reference]
        else {
            return nil
        }

        self.name = name
        self.image = imageAsset
        self.description = description
        self.difficulty = difficulty
        self.blocks = blocks
        self.record = record
    }
    init?(name: String, description: String, difficulty: String, image: CKAsset?, blocks: [CKRecord.Reference]) {
        let record = CKRecord(recordType: "Workouts")
        record["name"] = name
        record["description"] = description
        record["image"] = image
        record["difficulty"] = difficulty
        record["blocks"] = blocks
        self.init(record: record)
    }
}

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [WorkoutModel] = []
    @Published var isLoaded: Bool = false
    var cancellables = Set<AnyCancellable>()

    init(workoutIDs: [CKRecord.ID]) {
        fetchItems(workoutIDs: workoutIDs)
    }

    func fetchItems(workoutIDs: [CKRecord.ID]) {
        let predicate = NSPredicate(format: "recordID IN %@", workoutIDs)
        let recordType = "Workouts"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.workouts = returnedItems
                self?.isLoaded = true
            }
            .store(in: &cancellables)
    }
}

