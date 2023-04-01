//
//  LoginViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/31.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel
    fileprivate var currentNonce: String?
    
    private let kakaoLoginButton = {
        let button = UIButton()
        
        button.backgroundColor = .yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let appleLoginButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButton()
    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        let kakaoLoginAction = UIAction { _ in
            self.viewModel.kakaoLogin()
        }
        kakaoLoginButton.addAction(kakaoLoginAction, for: .touchUpInside)
        
        let appleLoginAction = UIAction { _ in
            let request = self.startSignInWithAppleFlow()
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
        appleLoginButton.addAction(appleLoginAction, for: .touchUpInside)
    }
    
    private func setupViews() {
        [kakaoLoginButton, appleLoginButton].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            kakaoLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            kakaoLoginButton.heightAnchor.constraint(equalTo: kakaoLoginButton.widthAnchor, multiplier: 0.2),
            
            appleLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            appleLoginButton.heightAnchor.constraint(equalTo: appleLoginButton.widthAnchor, multiplier: 0.2),
        ])
    }
    
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // 성공 후 동작
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
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
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: %@", error)
                    return
                }
                // Apple 계정으로 firebase에 로그인 됬다.
                print("애플로그인 완료")
            }
        }
        
    }

    // 실패시 동작
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension LoginViewController {
    func startSignInWithAppleFlow() -> ASAuthorizationAppleIDRequest {
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
