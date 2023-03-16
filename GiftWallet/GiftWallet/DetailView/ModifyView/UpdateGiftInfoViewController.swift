//
//  UserInfoModifyViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/22.
//

import UIKit

class UpdateGiftInfoViewController: UIViewController {
    
    private let viewModel: UpdateViewModel
    
    private let userProfileImageButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "testImagewoongPhoto"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let buttonLineView = {
       let view = UIView()
        
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let buttonLineLabel = {
       let label = UILabel()
        
        label.text = "편집"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let profileInfoLabel = {
       let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "프로필 정보"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nameLabel = {
       let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "이름"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputNameTextField = {
        let textField = CustomTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let completeButton = {
        let button = UIButton(type: .roundedRect)
        
        button.setTitle("변경하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(viewModel: UpdateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileImageButton.layer.cornerRadius = userProfileImageButton.frame.width / 2
        userProfileImageButton.clipsToBounds = true
        inputNameTextField.setupTextFieldBottomBorder()
    }
    
    private func setupButton() {
        let modifyAction = UIAction { [weak self] _ in
//            let formSheetViewController = FormSheetViewController()
//            formSheetViewController.modalPresentationStyle = .overFullScreen
//            formSheetViewController.modalTransitionStyle = .crossDissolve
//            self?.present(formSheetViewController, animated: true)
        }
        userProfileImageButton.addAction(modifyAction, for: .touchUpInside)
    }
    
    private func setupNavigation() {
        title = "프로필 편집"
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissViewController))
    }
    
    @objc
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [userProfileImageButton, profileInfoLabel, nameLabel, inputNameTextField, completeButton].forEach(view.addSubview(_:))
        userProfileImageButton.addSubview(buttonLineView)
        buttonLineView.addSubview(buttonLineLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            userProfileImageButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            userProfileImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            userProfileImageButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
            userProfileImageButton.heightAnchor.constraint(equalTo: userProfileImageButton.widthAnchor),
            
            buttonLineView.heightAnchor.constraint(equalTo: userProfileImageButton.heightAnchor, multiplier: 0.2),
            buttonLineView.widthAnchor.constraint(equalTo: userProfileImageButton.widthAnchor),
            buttonLineView.bottomAnchor.constraint(equalTo: userProfileImageButton.bottomAnchor, constant: 0),
            buttonLineView.centerXAnchor.constraint(equalTo: userProfileImageButton.centerXAnchor),
            
            buttonLineLabel.centerXAnchor.constraint(equalTo: buttonLineView.centerXAnchor),
            buttonLineLabel.centerYAnchor.constraint(equalTo: buttonLineView.centerYAnchor),
            
            profileInfoLabel.topAnchor.constraint(equalTo: userProfileImageButton.bottomAnchor, constant: 30),
            profileInfoLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            
            nameLabel.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: profileInfoLabel.leadingAnchor),
            
            inputNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            inputNameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            inputNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            inputNameTextField.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.05),
            
            completeButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            completeButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            completeButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07),
            completeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30)
        ])
    }
}

// MARK: Notification 관련
extension UpdateGiftInfoViewController {
    
}
