//
//  LoginViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/31.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel
    
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
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
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
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
//            let idToken = credentials.identityToken!
//            let tokenStr = String(data: idToken, encoding: .utf8)
//            print("tokenStr::" ,tokenStr)
//
//            guard let code = credentials.authorizationCode else { return }
//            let codeStr = String(data: code, encoding: .utf8)
//            print("codeStr:", codeStr)
//
//            let user = credentials.user
//            print("user:::", user)
//            ---
//
//            let firstName = credentials.fullName?.givenName
//            let lastName = credentials.fullName?.familyName
//            let email = credentials.email
//            print(firstName, lastName, email)
            break
            
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
    
    
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

