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
        
        label.font = .boldSystemFont(ofSize: 15)
        label.text = page.labelDescription
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputTextField = {
        let textField = CustomTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var actionButton = {
        let button = UIButton(type: .roundedRect)
        
        button.setTitle(page.buttonDescription, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputTextField.setupTextFieldBottomBorder()
    }
    
    private func setuptextInTextField() {
        inputTextField.clearButtonMode = .always
        inputTextField.clearsOnBeginEditing = true
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
                self.viewModel.buttonActionByPage(page: self.page, inputText)
                self.viewModel.createCoreData {
                    self.dismiss(animated: true)
                }
            }
        }
        actionButton.addAction(actionButtonAction, for: .touchUpInside)
    }
    
    private func sceneConversion() {
        guard let netxPage = Page(rawValue: page.rawValue + 1) else { return }
        let addViewController = AddViewController(viewModel: viewModel, page: netxPage)
        navigationController?.pushViewController(addViewController, animated: true)
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

//MARK: Keyboard 관련
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
        }
    }
}
