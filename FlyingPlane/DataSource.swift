//
//  DataSource.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 09.07.2023.
//

import Foundation

enum Speed: String {
    case slow
    case average
    case high
}

enum Plane: String {
    case plane1
    case plane2
    case plane3
}

protocol DataSource {
    func setSpeed(_ speed: Speed)
    func setPlane(_ plane: Plane)
    func getSpeed() -> Speed?
    func getPlane() -> Plane?
}

final class DataSourceImpl: DataSource {
    private let stateStorage = UserDefaults.standard
    
    func setSpeed(_ speed: Speed) {
        let str = String(describing: Speed.self)
        stateStorage.set(speed.rawValue, forKey: str)
    }

    func setPlane(_ plane: Plane) {
        let keyString = String(describing: Plane.self)
        stateStorage.set(plane.rawValue, forKey: keyString)
    }
    
    func getSpeed() -> Speed? {
        let keyString = String(describing: Speed.self)
        
        guard let value = stateStorage.object(forKey: keyString) as? String else {
            return nil
        }
                            
        return Speed(rawValue: value)
    }
    
    func getPlane() -> Plane? {
        let keyString = String(describing: Plane.self)
        
        guard let value = stateStorage.object(forKey: keyString) as? String else {
            return nil
        }
                            
        return Plane(rawValue: value)
    }
}
