//
//  LoginViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/28.
//

import UIKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    
    private let kakaoLoginButton = {
       let button = UIButton()
        
        button.setImage(UIImage(named: "kakao_login_medium_wide"), for: .normal)
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
//            self.viewModel.kakaoLogin()
            self.viewModel.checkToken()
        }
        kakaoLoginButton.addAction(kakaoLoginAction, for: .touchUpInside)
    }
    
    
    private func setupViews() {
        view.addSubview(kakaoLoginButton)
        
        NSLayoutConstraint.activate([
            kakaoLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            kakaoLoginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }

}
