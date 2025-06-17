//
//  SceneDelegate.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is already authenticated
        if AuthenticationManager.shared.isUserLoggedIn() {
            let mainTabBar = MainTabBarController()
            window?.rootViewController = mainTabBar
        } else {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navController
        }
        
        window?.makeKeyAndVisible()
    }
}
