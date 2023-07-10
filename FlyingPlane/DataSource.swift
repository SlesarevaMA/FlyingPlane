//
//  DataSource.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 09.07.2023.
//

import UIKit

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
    func addRecord(record: Int)
    func getRecords() -> [Int]
    func loadImage() -> UIImage?
    func saveImage(image: UIImage)
}

final class DataSourceImpl: DataSource {
    private let stateStorage = UserDefaults.standard
    private let fileManager = FileManager.default
    private var records = [Int]()
    
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
    
    func addRecord(record: Int) {
        records.append(record)
    }
    
    func getRecords() -> [Int] {
        return records
    }
    
    func loadImage() -> UIImage? {
        guard let fileName = stateStorage.object(forKey: "PersonImage") as? String else {
            return nil
        }
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }

    func saveImage(image: UIImage) {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        do {
            try data.write(to: fileURL)
            stateStorage.set(fileName, forKey: "PersonImage")
        } catch let error {
            print(error.localizedDescription)
            return
        }
    }
}
