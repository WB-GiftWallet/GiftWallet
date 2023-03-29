//
//  SocialLoginManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/28.
//

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

struct SocialLoginManager {

}



// MARK: 카카오 로그인 관련
extension SocialLoginManager {
    func checkLoginEnabledAndLogin(completion: @escaping (Result<User, Error>) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            logInWithUserApplication(completion: completion)
        } else {
            logInWithUserAccount(completion: completion)
        }
    }
    
    // 카카오
    private func logInWithUserApplication(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                print("오쓰토근:::::::::::", oauthToken?.accessToken)
                
                setUserInfo(completion: completion)
            }
        }
    }
    
    // 카톡(계정)으로 로그인
    private func logInWithUserAccount(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                print("오쓰토근:::::::::::", oauthToken)
                _ = oauthToken
                setUserInfo(completion: completion)
            }
        }
    }
    
    private func setUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.me { user, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let user = user else { return }
                completion(.success(user))
            }
        }
    }
}
