//
//  UserInfoModifyViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/22.
//

import UIKit

class UpdateGiftInfoViewController: UIViewController {
    
    private let viewModel: UpdateViewModel
    var delegate: GiftDidUpdateDelegate?
    
    private let userProfileImageButton = {
        let button = UIButton()
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.imageViewbackground.cgColor
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
    
    private let defaultSmallTitleLabel = {
       let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "상세 정보"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputBrandLabel = {
       let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "브랜드"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputBrandTextField = {
        let textField = CustomTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let inputProductNameLabel = {
       let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "상품명"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputProductNameTextField = {
        let textField = CustomTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let inputExpireDateLabel = {
       let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "유효기간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputExpireDateTextField = {
        let textField = CustomTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let completeButton = {
        let button = CustomButton()
        
        button.setTitle("변경하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(tapCompleteButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    private func tapCompleteButton() {
        var gift = viewModel.gift
        gift.brandName = inputBrandTextField.text
        gift.productName = inputBrandTextField.text
        gift.expireDate = DateFormatter.convertToDisplyStringToExpireDate(dateText: inputBrandTextField.text!)

        dismiss(animated: true) { [self] in
            self.delegate?.didUpdateGift(updatedGift: gift)
        }
    }
    
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
        configureImage()
        configureTextField()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileImageButton.layer.cornerRadius = userProfileImageButton.frame.width / 2
        userProfileImageButton.clipsToBounds = true
        // TODO: 수정
        inputBrandTextField.setupTextFieldBottomBorder()
        inputProductNameTextField.setupTextFieldBottomBorder()
        inputExpireDateTextField.setupTextFieldBottomBorder()
    }
    
    private func configureImage() {
        let image = viewModel.gift.image
        userProfileImageButton.setImage(image, for: .normal)
    }
    
    private func configureTextField() {
        inputBrandTextField.text = viewModel.gift.brandName
        inputProductNameTextField.text = viewModel.gift.productName
        inputExpireDateTextField.text = viewModel.gift.expireDate?.setupDateStyleForDisplay()
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
        
        userProfileImageButton.addSubview(buttonLineView)
        buttonLineView.addSubview(buttonLineLabel)
        
        [inputBrandLabel, inputBrandTextField, inputProductNameLabel, inputProductNameTextField, inputExpireDateLabel, inputExpireDateTextField].forEach(view.addSubview(_:))
        [userProfileImageButton, defaultSmallTitleLabel, completeButton].forEach(view.addSubview(_:))
        
        let safeArea = view.safeAreaLayoutGuide
        
        
        NSLayoutConstraint.activate([
                userProfileImageButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
                userProfileImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                userProfileImageButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
                userProfileImageButton.heightAnchor.constraint(equalTo: userProfileImageButton.widthAnchor),

                buttonLineLabel.centerXAnchor.constraint(equalTo: buttonLineView.centerXAnchor),
                buttonLineLabel.centerYAnchor.constraint(equalTo: buttonLineView.centerYAnchor),

                buttonLineView.heightAnchor.constraint(equalTo: userProfileImageButton.heightAnchor, multiplier: 0.2),
                buttonLineView.widthAnchor.constraint(equalTo: userProfileImageButton.widthAnchor),
                buttonLineView.bottomAnchor.constraint(equalTo: userProfileImageButton.bottomAnchor, constant: 0),
                buttonLineView.centerXAnchor.constraint(equalTo: userProfileImageButton.centerXAnchor),

                defaultSmallTitleLabel.topAnchor.constraint(equalTo: userProfileImageButton.bottomAnchor, constant: 10),
                defaultSmallTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
                
                inputBrandLabel.topAnchor.constraint(equalTo: defaultSmallTitleLabel.bottomAnchor, constant: 15),
                inputBrandLabel.leadingAnchor.constraint(equalTo: defaultSmallTitleLabel.leadingAnchor),
                
                inputBrandTextField.topAnchor.constraint(equalTo: inputBrandLabel.bottomAnchor, constant: 5),
                inputBrandTextField.leadingAnchor.constraint(equalTo: inputBrandLabel.leadingAnchor),
                
                inputProductNameLabel.topAnchor.constraint(equalTo: inputBrandTextField.bottomAnchor, constant: 30),
                inputProductNameLabel.leadingAnchor.constraint(equalTo: inputBrandLabel.leadingAnchor),
                
                inputProductNameTextField.topAnchor.constraint(equalTo: inputProductNameLabel.bottomAnchor, constant: 5),
                inputProductNameTextField.leadingAnchor.constraint(equalTo: inputBrandLabel.leadingAnchor),
                
                inputExpireDateLabel.topAnchor.constraint(equalTo: inputProductNameTextField.bottomAnchor, constant: 30),
                inputExpireDateLabel.leadingAnchor.constraint(equalTo: inputBrandLabel.leadingAnchor),
                
                inputExpireDateTextField.topAnchor.constraint(equalTo: inputExpireDateLabel.bottomAnchor, constant: 5),
                inputExpireDateTextField.leadingAnchor.constraint(equalTo: inputBrandLabel.leadingAnchor),
                
                inputBrandTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
                inputBrandTextField.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.05),
                inputProductNameTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
                inputProductNameTextField.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.05),
                inputExpireDateTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
                inputExpireDateTextField.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.05),

                completeButton.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),
                completeButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                completeButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07),
                completeButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.95),
        ])
        

        
    }
}

// MARK: Notification 관련
extension UpdateGiftInfoViewController {
    
}
