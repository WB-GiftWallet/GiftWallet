//
//  LoginViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/28.
//

import UIKit

class LoginViewController: UIViewController {

    private let kakaoLoginButton = {
       let button = UIButton()
        
        button.setImage(UIImage(named: "kakao_login_medium_wide"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
