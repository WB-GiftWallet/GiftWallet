//
//  LoginViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/31.
//

import Foundation
import AuthenticationServices

class LoginViewModel {
    private let kakaoLoginManager = KakaoLoginManager()
    private var appleLoginManager = AppleLoginManager()
    
    func kakaoLogin() {
        kakaoLoginManager.checkLoginEnabledAndLogin { result in
            switch result {
            case .success(let success):
                print("석세서:::::::::::::",success)
            case .failure(let failure):
                print("폴트:::::::::::::",failure)
            }
        }
    }
    
    func appleLogin() -> ASAuthorizationAppleIDRequest {
        return appleLoginManager.startSignInWithApple()
    }
    
    
    func didCompleteAppleLogin(controller: ASAuthorizationController, authorization: ASAuthorization, completion: @escaping () -> Void) {
        appleLoginManager.didCompleteLogin(controller: controller, authorization: authorization, completion: completion)
    }
    
}
