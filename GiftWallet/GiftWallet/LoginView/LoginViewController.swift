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
            let request = self.viewModel.appleLogin()
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
        appleLoginButton.addAction(appleLoginAction, for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
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
        viewModel.didCompleteAppleLogin(controller: controller, authorization: authorization) {
            let mainViewModel = MainViewModel()
            let etcSettingViewModel = EtcSettingViewModel()
            let mainTabBarController = MainTabBarController(mainViewModel: mainViewModel,
                                                            etcSettingViewModel: etcSettingViewModel)
            let navigationMainController = UINavigationController(rootViewController: mainTabBarController)
            self.present(navigationMainController, animated: true)
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
