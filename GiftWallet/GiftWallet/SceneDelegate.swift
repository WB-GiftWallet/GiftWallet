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
        
        let loginVC = LoginViewController()
        
        let mainViewModel = MainViewModel()
        let etcSettingViewModel = EtcSettingViewModel()
        let mainTabBarController = MainTabBarController(mainViewModel: mainViewModel,
                                                        etcSettingViewModel: etcSettingViewModel)
        let navigationMainController = UINavigationController(rootViewController: mainTabBarController)

        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { ( accessTokenInfo, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        window.rootViewController = loginVC
                    }
                    else {
                        //기타 에러
                        window.rootViewController = loginVC
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    window.rootViewController = navigationMainController
                }
            }
        }
        else {
            // hasToken() == false
            window.rootViewController = loginVC
        }
        
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        
    }
}
