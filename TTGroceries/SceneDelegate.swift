//
//  SceneDelegate.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let window = window,
           let viewController = GroceryListRouter.ListView.targetViewController() {
            let navController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navController
            viewController.view.backgroundColor = .brown
            window.makeKeyAndVisible()
        }
    }
}

