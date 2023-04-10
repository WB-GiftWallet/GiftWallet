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
    private let coreDataManager = CoreDataManager.shared
    private let firebaseManager = FireBaseManager.shared
    
    func kakaoLogin(completion: @escaping () -> Void) {
        kakaoLoginManager.checkLoginEnabledAndLogin { result in
            switch result {
            case .success(let user):
                guard let userEmail = user.kakaoAccount?.email,
                      let userID = user.id?.description else { return }
                self.firebaseManager.signInWithEmail(email: userEmail, password: userID) { gifts in
                    do {
                        try self.coreDataManager.updateAllData(gifts)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                completion()
                
            case .failure(let failure):
                print("폴트:::::::::::::",failure)
            }
        }
    }
    
    func appleLogin() -> ASAuthorizationAppleIDRequest {
        return appleLoginManager.startSignInWithApple()
    }
    
    
    func didCompleteAppleLogin(controller: ASAuthorizationController, authorization: ASAuthorization, completion: @escaping () -> Void) {
        appleLoginManager.didCompleteLogin(controller: controller, authorization: authorization) { userInfo in
            guard let idTokenString = userInfo["idTokenString"],
                  let rawNonce = userInfo["rawNonce"] else { return }
            let credentail = self.firebaseManager.makeAppleAuthProviderCredential(idToken: idTokenString, rawNonce: rawNonce)
            
            self.firebaseManager.signInWithCredential(authCredential: credentail) { gifts in
                do {
                    try self.coreDataManager.updateAllData(gifts)
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
