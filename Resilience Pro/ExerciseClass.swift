//
//  ExerciseClass.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 27/05/2023.
//

import SwiftUI
import CloudKit
import Combine

struct CloudKitExerciseModelNames {
    static let name = "name"
}

struct ExerciseModel: Hashable, CloudKitableProtocol {
    let name: String
    let description: String
    let image: CKAsset
    let difficulty: String
    let video: CKAsset
    let reps: Int
    let rest: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard
            let name = record[CloudKitExerciseModelNames.name] as? String,
            let description = record["description"] as? String,
            let imageAsset = record["image"] as? CKAsset,
            let difficulty = record["difficulty"] as? String,
            let videoAsset = record["video"] as? CKAsset,
            let reps = record["reps"] as? Int,
            let rest = record["rest"] as? Int
        else {
            return nil
        }
        
        self.name = name
        self.description = description
        self.image = imageAsset
        self.difficulty = difficulty
        self.video = videoAsset
        self.reps = reps
        self.rest = rest
        self.record = record
    }
    
    init?(name: String, description: String, difficulty: String, image: CKAsset?, video: CKAsset?, reps: Int, rest: Int) {
        let record = CKRecord(recordType: "Exercises")
        record["name"] = name
        record["description"] = description
        record["difficulty"] = difficulty
        record["image"] = image
        record["video"] = video
        record["reps"] = reps
        record["rest"] = rest
        self.init(record: record)
    }
}

class ExercisesViewModel: ObservableObject {
    @Published var exercises: [ExerciseModel] = []
    @Published var isLoaded: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    init(exerciseIDs: [CKRecord.ID]) {
        fetchItems(exerciseIDs: exerciseIDs)
    }
    
    func fetchItems(exerciseIDs: [CKRecord.ID]) {
        let predicate = NSPredicate(format: "recordID IN %@", exerciseIDs)
        let recordType = "Exercises"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.exercises = returnedItems
                self?.isLoaded = true
                print(returnedItems)
            }
            .store(in: &cancellables)
    }
}
