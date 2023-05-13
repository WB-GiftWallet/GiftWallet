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
}

extension LoginViewModel {
    func kakaoLogin(completion: @escaping () -> Void,
                    updateUserProfileCompletion: @escaping () -> Void,
                    updateDataCompletion: @escaping () -> Void) {
        kakaoLoginManager.checkLoginEnabledAndLogin { [weak self] result in
            switch result {
            case .success(let user):
                guard let userEmail = user.kakaoAccount?.email,
                      let userID = user.id?.description,
                      let userName = user.properties,
                      let userNickName = userName["nickname"] else { return }
                self?.firebaseManager.signInWithEmail(email: userEmail, password: userID) { [weak self] gifts in
                    self?.firebaseManager.changeProfile(name: userNickName, completion: updateUserProfileCompletion)
                    
                    do {
                        try self?.coreDataManager.updateAllData(gifts, completion: updateDataCompletion)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createAppleSignInRequest() -> ASAuthorizationAppleIDRequest {
        return appleLoginManager.createAppleSignInRequest()
    }
    
    
    func didCompleteAppleLogin(controller: ASAuthorizationController,
                               authorization: ASAuthorization,
                               completion: @escaping () -> Void,
                               updateUserProfileCompletion: @escaping () -> Void,
                               updateDataCompletion: @escaping () -> Void) {
        appleLoginManager.handleAppleSignInCompletion(controller: controller, authorization: authorization) { [weak self] userInfo in
            guard let idTokenString = userInfo["idTokenString"],
                  let rawNonce = userInfo["rawNonce"],
                  let fullName = userInfo["fullName"],
                  let self = self else { return }
            
            let credentail = self.firebaseManager.makeAppleAuthProviderCredential(idToken: idTokenString, rawNonce: rawNonce)
            
            self.firebaseManager.signInWithCredential(authCredential: credentail) { [weak self] gifts in
                if fullName != "" {
                    self?.firebaseManager.changeProfile(name: fullName, completion: updateUserProfileCompletion)
                }
                
                do {
                    try self?.coreDataManager.updateAllData(gifts, completion: updateDataCompletion)
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

