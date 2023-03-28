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
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
