//
//  SceneDelegate.swift
//  GiftWallet
//
//  Created by WB on 2023/02/19.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let socialLoginManager = SocialLoginManager()
        
        let loginVC = LoginViewController()
        
        let mainViewModel = MainViewModel()
        let etcSettingViewModel = EtcSettingViewModel()
        let mainTabBarController = MainTabBarController(mainViewModel: mainViewModel,
                                                        etcSettingViewModel: etcSettingViewModel)
        let navigationMainController = UINavigationController(rootViewController: mainTabBarController)

        socialLoginManager.checkToken { hasToken in
            switch hasToken {
            case true:
                window.rootViewController = navigationMainController
            case false:
                window.rootViewController = loginVC
            }
        }
        
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
    }
}
