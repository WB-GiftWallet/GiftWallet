//
//  SceneDelegate.swift
//  GiftWallet
//
//  Created by WB on 2023/02/19.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        //MARK: Conneting MainView
        let mainViewModel = MainViewModel()
        let etcSettingViewModel = EtcSettingViewModel()
        let mainTabBarController = MainTabBarController(mainViewModel: mainViewModel,
                                                        etcSettingViewModel: etcSettingViewModel)
        let navigationMainController = UINavigationController(rootViewController: mainTabBarController)
        
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        window.backgroundColor = .white
        window.rootViewController = loginViewController
        
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
}
