//
//  RecordsRepository.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 25.07.2023.
//

import Foundation

protocol RecordsRepository {
    func addRecord(name: String, score: Int)
    func getRecords() -> [RecordModel]
    func saveRecords()
}

final class RecordsRepositoryImpl: RecordsRepository {
    private let stateStorage: UserDefalutsProtocol
    private var records = [String: Int]()

    init(userDefaults: UserDefalutsProtocol = UserDefaults.standard) {
        stateStorage = userDefaults
    }

    func addRecord(name: String, score: Int) {
        records[name] = score
    }
    
    func getRecords() -> [RecordModel] {
        guard let records = stateStorage.object(forKey: Records.current.rawValue) as? [String: Int] else {
            return [RecordModel]()
        }
        
        var result = [RecordModel]()
        let number = 1
        
        for record in records.enumerated() {
            result.append(
                RecordModel(
                    number: record.offset + number,
                    score: record.element.value,
                    name: record.element.key
                )
            )
        }
        
        return result
    }
    
    func saveRecords() {
        stateStorage.set(records, forKey: Records.current.rawValue)
    }
}
