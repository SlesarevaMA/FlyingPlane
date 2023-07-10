//
//  SceneDelegate.swift
//  FlyingPlane
//
//  Created by Margarita Slesareva on 15.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let dataSource: DataSource = DataSourceImpl()
        let viewController = MainViewController(dataSource: dataSource)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
