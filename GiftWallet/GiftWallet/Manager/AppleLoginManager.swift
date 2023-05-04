//
//  AppleLoginManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/04/01.
//

import AuthenticationServices
import CryptoKit

// MARK: 애플 로그인 관련

struct AppleLoginManager {
    private var currentNonce: String?
}


extension AppleLoginManager {
    func didCompleteLogin(controller: ASAuthorizationController, authorization: ASAuthorization, completion: @escaping ([String: String]) -> Void) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalidstate: 로그인 콜백이 수신되었지만 로그인 요청이 전송되지 않았습니다.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("ID토큰을 가져올 수 없습니다.")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("데이터에서 토큰 문자열을 나열할 수 없습니다: \(appleIDToken.debugDescription)")
                return
            }
            
            if let givenName = appleIDCredential.fullName?.givenName,
               let familyName = appleIDCredential.fullName?.familyName {
                
                let fullName = "\(familyName)\(givenName)"
                
                completion(["idTokenString": idTokenString, "rawNonce": nonce, "fullName": fullName])
            } else {
                guard let fullName = appleIDCredential.fullName?.description else { return }
                
                completion(["idTokenString": idTokenString, "rawNonce": nonce, "fullName": fullName])
            }
            
        }
        
    }
    
    mutating func startSignInWithApple() -> ASAuthorizationAppleIDRequest {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        return request
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0 )
        }.joined()
        
        return hashString
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
}
