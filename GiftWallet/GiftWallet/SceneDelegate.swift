//
//  SceneDelegate.swift
//  GiftWallet
//
//  Created by WB on 2023/02/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let mainTabBarController = MainTabBarController()
        let navigationMainController = UINavigationController(rootViewController: mainTabBarController)
        window.backgroundColor = .white
        window.rootViewController = navigationMainController
        window.makeKeyAndVisible()
        self.window = window
    }
}
