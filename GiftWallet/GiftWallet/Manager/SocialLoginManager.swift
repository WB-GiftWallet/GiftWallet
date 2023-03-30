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
    
    // 카카오(앱)으로 로그인)
    private func logInWithUserApplication(completion: @escaping (Result<User, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                
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
