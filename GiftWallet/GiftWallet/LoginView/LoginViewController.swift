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
    var delegate: DidFetchGiftDelegate?
    fileprivate var currentNonce: String?
    
    
    private let kakaoLoginButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 12.0
        button.backgroundColor = UIColor.kakaoButton
        button.setTitle("카카오 로그인", for: .normal)
        button.setTitleColor(UIColor.kakaoButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setImage(UIImage(named: "kakao.ball")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tintColor = .black
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let appleLoginButton = {
        let button = UIButton()
                
        button.layer.cornerRadius = 12.0
        button.backgroundColor = .black
        button.setTitle("Apple로 로그인", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private let buttonVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
            self.viewModel.kakaoLogin {
                self.dismiss(animated: true)
            } updateDataCompletion: {
                self.delegate?.finishedFetch()
            }
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
        
        [kakaoLoginButton, appleLoginButton].forEach(buttonVerticalStackView.addArrangedSubview(_:))
        [buttonVerticalStackView].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            buttonVerticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonVerticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 300),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 45),
            
            appleLoginButton.widthAnchor.constraint(equalToConstant: 300),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // 성공 후 동작
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.viewModel.didCompleteAppleLogin(controller: controller, authorization: authorization) {
            self.dismiss(animated: true)
        } updateDataCompletion: {
            self.delegate?.finishedFetch()
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

protocol DidFetchGiftDelegate {
    func finishedFetch()
}
