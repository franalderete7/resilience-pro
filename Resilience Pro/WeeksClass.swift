//
//  WeeksClass.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI
import CloudKit
import Combine

struct CloudKitWeekModelNames {
    static let name = "name"
}

struct WeekModel: Hashable, CloudKitableProtocol {
    let name: String
    var workouts: [CKRecord.Reference] = []
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard
            let name = record[CloudKitWeekModelNames.name] as? String,
            let workouts = record["workouts"] as? [CKRecord.Reference]
        else {
            return nil
        }

        self.name = name
        self.workouts = workouts
        self.record = record
    }

    
    init?(name: String, workouts: [CKRecord.Reference]) {
        let record = CKRecord(recordType: "Weeks")
        record["name"] = name
        record["workouts"] = workouts
        self.init(record: record)
    }
    
    func update(newName: String) -> WeekModel? {
        let record = record
        record["name"] = newName
        return WeekModel(record: record)
    }
}

class WeeksViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var weeks: [WeekModel] = []
    @Published var isLoaded: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    init(weekIDs: [CKRecord.ID]) {
        fetchItems(weekIDs: weekIDs)
    }
    
    func fetchItems(weekIDs: [CKRecord.ID]) {
        let predicate = NSPredicate(format: "recordID IN %@", weekIDs)
        let recordType = "Weeks"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.weeks = returnedItems
                self?.isLoaded = true
            }
            .store(in: &cancellables)
    }
}


