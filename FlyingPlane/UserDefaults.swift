//
//  UserDefaults.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 25.07.2023.
//

import Foundation

protocol UserDefalutsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefalutsProtocol { }
