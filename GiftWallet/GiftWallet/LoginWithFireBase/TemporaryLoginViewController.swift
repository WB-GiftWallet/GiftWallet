//
//  TemporaryLoginViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/23.
//

import UIKit

class TemporaryLoginViewController: UIViewController {
    
    let viewModel = TemporaryLoginViewModel()
    
    let loginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("  로  그  인  ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let idTextField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "ID 입력"
        
        return field
    }()
    
    let passWordTextField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "Password 입력"
        
        return field
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        setupLayout()
        buttonAddTarget()
    }
    
    func setupLayout() {
        
        view.addSubview(stackView)
        
        [idTextField, passWordTextField, loginButton].forEach(stackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func buttonAddTarget() {
        loginButton.addTarget(nil, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton() {
        print("Tapped Login Button")
    }
}
