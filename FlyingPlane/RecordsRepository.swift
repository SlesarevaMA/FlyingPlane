//
//  RecordsRepository.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 25.07.2023.
//

import Foundation

protocol RecordsRepository {
    func addRecord(record: Int)
    func getRecords() -> [Int]
}

final class RecordsRepositoryImpl: RecordsRepository {
    private let stateStorage: UserDefalutsProtocol
    private var records = [Int]()

    init(userDefaults: UserDefalutsProtocol = UserDefaults.standard) {
        stateStorage = userDefaults
    }

    func addRecord(record: Int) {
        records.append(record)
    }
    
    func getRecords() -> [Int] {
        return records
    }
}
