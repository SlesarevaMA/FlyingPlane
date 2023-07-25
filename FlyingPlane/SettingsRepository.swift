//
//  SettingsRepository.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 09.07.2023.
//

import UIKit

protocol SettingsRepository {
    func setSpeed(_ speed: Speed)
    func setPlane(_ plane: Plane)
    func getSpeed() -> Speed?
    func getPlane() -> Plane?
    func loadPersonImage(comletion: @escaping (UIImage?) -> Void)
    func saveImage(image: UIImage)
}

final class SettingsRepositoryImpl: SettingsRepository {
    private let stateStorage: UserDefalutsProtocol
    private let fileManager = FileManager.default
    
    init(userDefaults: UserDefalutsProtocol = UserDefaults.standard) {
        stateStorage = userDefaults
    }
    
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
        
        guard let value = stateStorage.string(forKey: keyString) else {
            return nil
        }
                            
        return Speed(rawValue: value)
    }
    
    func getPlane() -> Plane? {
        let keyString = String(describing: Plane.self)
        
        guard let value = stateStorage.string(forKey: keyString) else {
            return nil
        }
                            
        return Plane(rawValue: value)
    }
    
    func loadPersonImage(comletion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = self.loadPersonImage() else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                comletion(image)
            }
        }
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
    
    private func loadPersonImage() -> Data? {
        guard let fileName = stateStorage.object(forKey: "PersonImage") as? String else {
            return nil
        }
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }
}
