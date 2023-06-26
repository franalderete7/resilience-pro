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
    var act_one: [CKRecord.Reference] = []
    var act_two: [CKRecord.Reference] = []
    var block_one: [CKRecord.Reference] = []
    var block_two: [CKRecord.Reference] = []
    var block_three: [CKRecord.Reference] = []
    var block_four: [CKRecord.Reference] = []
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard
            let name = record[CloudKitProgramModelNames.name] as? String,
            let imageAsset = record["image"] as? CKAsset,
            let description = record["description"] as? String,
            let difficulty = record["difficulty"] as? String,
            let blocks = record["blocks"] as? [CKRecord.Reference],
            let act_one = record["act_one"] as? [CKRecord.Reference],
            let act_two = record["act_two"] as? [CKRecord.Reference],
            let block_one = record["block_one"] as? [CKRecord.Reference],
            let block_two = record["block_two"] as? [CKRecord.Reference],
            let block_three = record["block_three"] as? [CKRecord.Reference],
            let block_four = record["block_four"] as? [CKRecord.Reference]
        else {
            return nil
        }

        self.name = name
        self.image = imageAsset
        self.description = description
        self.difficulty = difficulty
        self.blocks = blocks
        self.act_one = act_one
        self.act_two = act_two
        self.block_one = block_one
        self.block_two = block_two
        self.block_three = block_three
        self.block_four = block_four
        self.record = record
    }
    
    init?(name: String, description: String, difficulty: String, image: CKAsset?, blocks: [CKRecord.Reference], act_one: [CKRecord.Reference], act_two: [CKRecord.Reference], block_one: [CKRecord.Reference], block_two: [CKRecord.Reference], block_three: [CKRecord.Reference], block_four: [CKRecord.Reference]) {
        let record = CKRecord(recordType: "Workouts")
        record["name"] = name
        record["description"] = description
        record["image"] = image
        record["difficulty"] = difficulty
        record["blocks"] = blocks
        record["act_one"] = act_one
        record["act_two"] = act_two
        record["block_one"] = block_one
        record["block_two"] = block_two
        record["block_three"] = block_three
        record["block_four"] = block_four
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
