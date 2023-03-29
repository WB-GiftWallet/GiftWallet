//
//  SceneDelegate.swift
//  GiftWallet
//
//  Created by WB on 2023/02/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let socialLoginManager = SocialLoginManager()
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // 처리를 해야함? (계정정보를 처리해야함.)
//        socialLoginManager.checkToken()
        // 액세스토큰인포가 nil이면 -> LoginVC로 이동
        // 액세스토큰인포가 있다면 -> 파이어베이스 로그인? 어떻게? -> MainVC로 이동
        
        let loginViewController = LoginViewController()
        
        
//        let mainViewModel = MainViewModel()
//        let etcSettingViewModel = EtcSettingViewModel()
//        let mainTabBarController = MainTabBarController(mainViewModel: mainViewModel,
//                                                        etcSettingViewModel: etcSettingViewModel)
//        let navigationMainController = UINavigationController(rootViewController: mainTabBarController)
        window.backgroundColor = .white
        window.rootViewController = loginViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
