//
//  AddViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import UIKit

class AddViewController: UIViewController {
    
    let page: Page
    let viewModel: AddViewModel
    
    private lazy var giftImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = viewModel.selectedImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var inputDescriptionLabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .medium, size: 15)
        label.text = page.labelDescription
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var inputTextField = {
        let textField = CustomTextField()
        
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var actionButton = {
        let button = CustomButton()
        
        button.setTitle(page.buttonDescription, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(viewModel: AddViewModel, page: Page) {
        self.viewModel = viewModel
        self.page = page
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
        setuptextInTextField()
        setupDatePicekrInputViewWhenPageIsExpireDate()
        updateButtonForTextFieldState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputTextField.setupTextFieldBottomBorder()
    }
    
    private func setuptextInTextField() {
        inputTextField.text = viewModel.getTextsFromSeletedImage(page: page)
    }
    
    private func setupButton() {
        let actionButtonAction = UIAction { [weak self] _ in
            guard let self = self,
                  let inputText = self.inputTextField.text else { return }
            switch self.page {
            case .brand:
                self.viewModel.buttonActionByPage(page: self.page, inputText)
                self.sceneConversion()
            case .productName:
                self.viewModel.buttonActionByPage(page: self.page, inputText)
                self.sceneConversion()
            case .expireDate:
                self.expireDatePageAction(inputText: inputText)
            }
        }
        actionButton.addAction(actionButtonAction, for: .touchUpInside)
    }
    
    private func expireDatePageAction(inputText: String) {
        if viewModel.currentUser == nil {
            showLoginAlert()
        } else {
            self.viewModel.buttonActionByPage(page: self.page, inputText)
            self.viewModel.createLocalDBAndRemoteDB {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func sceneConversion() {
        guard let netxPage = Page(rawValue: page.rawValue + 1) else { return }
        let addViewController = AddViewController(viewModel: viewModel, page: netxPage)
        navigationController?.pushViewController(addViewController, animated: true)
    }
    
    private func loginViewSceneConversion() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.modalPresentationStyle = .overFullScreen
        present(loginViewController, animated: true)
    }
    
    private func setupNavigation() {
        title = ""
        
        let closeAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        let buttonImage = UIImage(systemName: "multiply")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImage,
                                                            primaryAction: closeAction)
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func showLoginAlert() {
        let alertController = UIAlertController(title: "로그인이 필요합니다.", message: "로그인 할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            self.loginViewSceneConversion()
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        [giftImageView, inputDescriptionLabel, inputTextField, actionButton].forEach(view.addSubview(_:))
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            giftImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            giftImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            giftImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            giftImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.6),
            giftImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            inputDescriptionLabel.topAnchor.constraint(equalTo: giftImageView.bottomAnchor, constant: 30),
            inputDescriptionLabel.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
            
            inputTextField.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.05),
            inputTextField.topAnchor.constraint(equalTo: inputDescriptionLabel.bottomAnchor, constant: 15),
            inputTextField.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
            
            actionButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -30),
            actionButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            actionButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07)
        ])
    }
}

//MARK: ExpireDate(DatePicker) Keyboard 관련
extension AddViewController {
    private func setupDatePicekrInputViewWhenPageIsExpireDate() {
        if page == .expireDate {
            setupDatePicekrAttributes()
        }
    }
    
    private func setupDatePicekrAttributes() {
        let datePickerView = UIDatePicker()
        var components = DateComponents()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy. MM. dd"
        components.day = 0
        
        datePickerView.sizeToFit()
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.locale = Locale(identifier: "ko-KR")
        
        let minimumDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        datePickerView.minimumDate = minimumDate
        
        datePickerView.addTarget(self,
                                 action: #selector(valueChangedDatePicker(sender:)),
                                 for: .valueChanged)
        
        if let dateText = inputTextField.text,
           let date = dateFormatter.date(from: dateText){
            datePickerView.setDate(date, animated: true)
        }
        
        inputTextField.inputView = datePickerView
        inputTextField.inputView?.backgroundColor = .white
    }
    
    @objc
    private func valueChangedDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if inputTextField.isFirstResponder {
            inputTextField.text = dateFormatter.string(from: sender.date)
            updateButtonForTextFieldState()
        }
    }
}

// MARK: 텍스트필드 비활성화 & 활성화 관련
extension AddViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let brandName = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if brandName.isEmpty {
            setActionButtonEnabled(false)
        } else {
            setActionButtonEnabled(true)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == " " {
            textField.text = .init()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        setActionButtonEnabled(false)
        return true
    }
    
    private func updateButtonForTextFieldState() {
        if inputTextField.text?.isEmpty == true {
            setActionButtonEnabled(false)
        } else {
            setActionButtonEnabled(true)
        }
    }
    
    private func setActionButtonEnabled(_ isEnabled: Bool) {
        if isEnabled {
            actionButton.isEnabled = true
            actionButton.backgroundColor = .customButton
        } else {
            actionButton.isEnabled = false
            actionButton.backgroundColor = .unenableButton
        }
    }
}
