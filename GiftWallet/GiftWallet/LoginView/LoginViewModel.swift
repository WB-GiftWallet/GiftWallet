//
//  LoginViewModel.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/28.
//

import Foundation

class LoginViewModel {
    
    private let socialLoginManager = SocialLoginManager()
    
    func kakaoLogin() {
        socialLoginManager.checkLoginEnabledAndLogin { result in
            switch result {
            case .success(let success):
                print(success)
                // TODO: Firebase 처리로직
                // TODO: Keychain 저장로직?
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func checkToken() {
//        socialLoginManager.checkToken()
    }
    
}
