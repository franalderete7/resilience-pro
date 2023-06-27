//
//  ProgramsClass.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI
import CloudKit
import Combine

struct CloudKitProgramModelNames {
    static let name = "name"
}

struct ProgramModel: Hashable, CloudKitableProtocol {
    let name: String
    let description: String
    let image: CKAsset
    let difficulty: String
    var weeks: [CKRecord.Reference] = []
    let week_count: Int
    var week_one: [CKRecord.Reference] = []
    var week_two: [CKRecord.Reference] = []
    var week_three: [CKRecord.Reference] = []
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard
            let name = record[CloudKitProgramModelNames.name] as? String,
            let imageAsset = record["image"] as? CKAsset,
            let description = record["description"] as? String,
            let difficulty = record["difficulty"] as? String,
            let weeks = record["weeks"] as? [CKRecord.Reference],
            let week_count = record["week_count"] as? Int,
            let week_one = record["week_one"] as? [CKRecord.Reference],
            let week_two = record["week_two"] as? [CKRecord.Reference],
            let week_three = record["week_three"] as? [CKRecord.Reference]
        else {
            return nil
        }

        self.name = name
        self.image = imageAsset
        self.description = description
        self.difficulty = difficulty
        self.weeks = weeks
        self.week_count = week_count
        self.week_one = week_one
        self.week_two = week_two
        self.week_three = week_three
        self.record = record
    }

    init?(name: String, description: String, image: CKAsset, difficulty: String, weeks: [CKRecord.Reference], week_count: Int, week_one: [CKRecord.Reference], week_two: [CKRecord.Reference], week_three: [CKRecord.Reference]) {
        let record = CKRecord(recordType: "Programs")
        record["name"] = name
        record["description"] = description
        record["image"] = image
        record["difficulty"] = difficulty
        record["weeks"] = weeks
        record["week_count"] = week_count
        record["week_one"] = week_one
        record["week_two"] = week_two
        record["week_three"] = week_three
        self.init(record: record)
    }

    func update(newName: String) -> ProgramModel? {
        let record = record
        record["name"] = newName
        return ProgramModel(record: record)
    }
}

class ProgramsViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var programs: [ProgramModel] = []
    @Published var isLoaded: Bool = false
    var cancellables = Set<AnyCancellable>()

    init() {
        fetchItems()
    }

    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let recordType = "Programs"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { [weak self] returnedItems in
                self?.programs = returnedItems
                self?.isLoaded = true
                print(returnedItems)
            }
            .store(in: &cancellables)
    }
}
