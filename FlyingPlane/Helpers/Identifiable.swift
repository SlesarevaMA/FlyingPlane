//
//  Identifiable.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 10.07.2023.
//

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

extension Identifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
