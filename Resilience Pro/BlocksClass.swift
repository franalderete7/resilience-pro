//
//  BlocksClass.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI
import CloudKit
import Combine

struct CloudKitBlockModelNames {
    static let name = "name"
    static let exercises = "exercises"
}

struct BlockModel: Hashable, CloudKitableProtocol {
    let name: String
    var exercises: [CKRecord.Reference] = []
    let record: CKRecord

    init?(record: CKRecord) {
        guard
            let name = record[CloudKitBlockModelNames.name] as? String,
            let exercises = record["exercises"] as? [CKRecord.Reference]
        else {
            return nil
        }

        self.name = name
        self.exercises = exercises
        self.record = record
    }

    init?(name: String, exercises: [CKRecord.Reference]) {
        let record = CKRecord(recordType: "Blocks")
        record["name"] = name
        record["exercises"] = exercises
        self.init(record: record)
    }
}

class BlocksViewModel: ObservableObject {
    @Published var blocks: [BlockModel] = []
    @Published var isLoaded: Bool = false
    var cancellables = Set<AnyCancellable>()

    init(blockIDs: [CKRecord.ID]) {
        fetchItems(blockIDs: blockIDs)
    }

    func fetchItems(blockIDs: [CKRecord.ID]) {
        let predicate = NSPredicate(format: "recordID IN %@", blockIDs)
        let recordType = "Blocks"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.blocks = returnedItems
                self?.isLoaded = true
            }
            .store(in: &cancellables)
    }
}
