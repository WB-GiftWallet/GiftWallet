//
//  LoginViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/28.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    
    private let kakaoLoginButton = {
       let button = UIButton()
        
        button.setImage(UIImage(named: "kakao_login_medium_wide"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // TODO: 카카오 버튼 & 애플 버튼 커스텀해야함. (디자인통일성)
    private let appleLoginButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        
        button.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButton()
    }
    
    private func setupButton() {
        let kakaoLoginAction = UIAction { _ in
            self.viewModel.kakaoLogin()
        }
        kakaoLoginButton.addAction(kakaoLoginAction, for: .touchUpInside)
    }
    
    
    private func setupViews() {
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        
        NSLayoutConstraint.activate([
            kakaoLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            kakaoLoginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            appleLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 300),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }

}
