//
//  TemporaryLoginViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/28.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TemporaryLoginViewController: UIViewController {
    
    let viewModel = TemporaryLoginViewModel()
    var handle: AuthStateDidChangeListenerHandle?
    var db = Firestore.firestore()
    
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
    
    let logOutButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" LogOut ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let addGiftButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" Make  Gift  Data ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let printButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" 출 력 버 튼 ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let addFireStoreButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" Add FireStore ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        setupLayout()
    }
  
    func setupLayout() {
        
        view.addSubview(stackView)
        
        [idTextField, passWordTextField, loginButton, logOutButton, addGiftButton, printButton, addFireStoreButton].forEach(stackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
