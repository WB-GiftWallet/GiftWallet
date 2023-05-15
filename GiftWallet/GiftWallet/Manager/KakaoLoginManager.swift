//
//  KakaoLoginManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/31.
//

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

struct KakaoLoginManager {
}

// MARK: 카카오로그인관련
extension KakaoLoginManager {
    func checkLoginEnabledAndLogin(completion: @escaping (Result<User, Error>) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            logInWithUserApplication(completion: completion)
        } else {
            logInWithUserAccount(completion: completion)
        }
    }
    
    // 카카오(앱)으로 로그인)
    private func logInWithUserApplication(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                getUserInfo(completion: completion)
            }
        }
    }
    
    // 카톡(계정)으로 로그인
    private func logInWithUserAccount(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                getUserInfo(completion: completion)
            }
        }
    }
    
    private func getUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
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

//MARK: 현재, 사용되지않는 코드
extension KakaoLoginManager {
    func checkToken(handler: @escaping (Bool) -> Void) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { ( accessTokenInfo, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        handler(false)
                    }
                    else {
                        //기타 에러
                        handler(false)
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    handler(true)
                }
            }
        }
        else {
            // hasToken() == false
            handler(false)
        }
    }
}


