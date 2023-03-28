//
//  UpdateGiftInfoViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/22.
//

import UIKit
import PhotosUI

class UpdateGiftInfoViewController: UIViewController {
    
    private let viewModel: UpdateViewModel
    var delegate: GiftDidUpdateDelegate?
    
    private let giftImageButton = {
        let button = UIButton()
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.imageViewbackground.cgColor
        button.addTarget(nil, action: #selector(tapImageButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc
    private func tapImageButton() {
        presentPHPicekrViewController()
    }
    
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
        setupTextFieldAttributes()
        configureTextField()
        setupExpireDateTextField()
        updateButtonForTextFieldState()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupButtonStyle()
        setupTextFieldStyle()
    }
    
    @objc
    private func tapCompleteButton() {
        inputtedTextsToGift()
        viewModel.coreDataUpdate()
        
        dismiss(animated: true) { [self] in
            NotificationCenter.default.post(name: NSNotification.Name("UpdateGiftInfoVC"), object: viewModel.gift)
        }
    }
    
    private func inputtedTextsToGift() {
        guard let buttonImageView = giftImageButton.imageView,
              let settedButtonImage = buttonImageView.image,
              let inputExpireDate = inputExpireDateTextField.text else { return }
        
        viewModel.gift.brandName = inputBrandTextField.text
        viewModel.gift.productName = inputProductNameTextField.text
        viewModel.gift.expireDate = DateFormatter.convertToDisplyStringToExpireDate(dateText: inputExpireDate)
        viewModel.gift.image = settedButtonImage
    }
    
    
    private func configureImage() {
        let image = viewModel.gift.image
        giftImageButton.setImage(image, for: .normal)
    }
    
    private func configureTextField() {
        inputBrandTextField.text = viewModel.gift.brandName
        inputProductNameTextField.text = viewModel.gift.productName
        inputExpireDateTextField.text = viewModel.gift.expireDate?.setupDateStyleForInputDisplay()
    }
    
    private func setupTextFieldAttributes() {
        [inputBrandTextField, inputProductNameTextField, inputExpireDateTextField].forEach { $0.delegate = self }
    }
    
    private func setupExpireDateTextField() {
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

        if let dateText = inputExpireDateTextField.text,
           let date = dateFormatter.date(from: dateText){
            datePickerView.setDate(date, animated: true)
        }
        
        inputExpireDateTextField.inputView = datePickerView
        inputExpireDateTextField.inputView?.backgroundColor = .white
    }
    
    @objc
    private func valueChangedDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if inputExpireDateTextField.isFirstResponder {
            inputExpireDateTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    
    private func setupNavigation() {
        title = "정보수정"
        
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
        
        giftImageButton.addSubview(buttonLineView)
        buttonLineView.addSubview(buttonLineLabel)
        
        [inputBrandLabel, inputBrandTextField, inputProductNameLabel, inputProductNameTextField, inputExpireDateLabel, inputExpireDateTextField].forEach(view.addSubview(_:))
        [giftImageButton, defaultSmallTitleLabel, completeButton].forEach(view.addSubview(_:))
        
        let safeArea = view.safeAreaLayoutGuide
        
        
        NSLayoutConstraint.activate([
            giftImageButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            giftImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            giftImageButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
            giftImageButton.heightAnchor.constraint(equalTo: giftImageButton.widthAnchor),
            
            buttonLineLabel.centerXAnchor.constraint(equalTo: buttonLineView.centerXAnchor),
            buttonLineLabel.centerYAnchor.constraint(equalTo: buttonLineView.centerYAnchor),
            
            buttonLineView.heightAnchor.constraint(equalTo: giftImageButton.heightAnchor, multiplier: 0.2),
            buttonLineView.widthAnchor.constraint(equalTo: giftImageButton.widthAnchor),
            buttonLineView.bottomAnchor.constraint(equalTo: giftImageButton.bottomAnchor, constant: 0),
            buttonLineView.centerXAnchor.constraint(equalTo: giftImageButton.centerXAnchor),
            
            defaultSmallTitleLabel.topAnchor.constraint(equalTo: giftImageButton.bottomAnchor, constant: 10),
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
            
            completeButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -30),
            completeButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07),
            completeButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
        ])
    }
    
    private func setupTextFieldStyle() {
        [inputBrandTextField, inputProductNameTextField, inputExpireDateTextField].forEach { $0.setupTextFieldBottomBorder() }
    }
    
    private func setupButtonStyle() {
        giftImageButton.layer.cornerRadius = giftImageButton.frame.width / 2
        giftImageButton.clipsToBounds = true
    }
}

// MARK: PHPickerViewController 관련
extension UpdateGiftInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty {
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true) {
                guard let formattedImage = self.getImage(results: results) else { return }
                self.giftImageButton.setImage(formattedImage, for: .normal)
            }
        }
    }
    
    private func presentPHPicekrViewController() {
        let configuration = setupPHPicekrConfiguration()
        let pickerViewController = PHPickerViewController(configuration: configuration)
        
        pickerViewController.delegate = self
        pickerViewController.modalPresentationStyle = .fullScreen
        
        present(pickerViewController, animated: true)
    }
    
    private func setupPHPicekrConfiguration() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selectionLimit = 1
        
        return configuration
    }
    
    private func getImage(results: [PHPickerResult]) -> UIImage? {
        var formattedImage: UIImage?
        guard let itemProvider = results.first?.itemProvider else { return nil }
        
        let semaphore = DispatchSemaphore(value: 0)
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    formattedImage = image as? UIImage
                }
                semaphore.signal()
            })
        }
        semaphore.wait()
        
        return formattedImage
    }
}

// MARK: 텍스트필드 비활성화 & 활성화 관련
extension UpdateGiftInfoViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let brandName = inputBrandTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let productName = inputProductNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let expireDate = inputExpireDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if brandName.isEmpty || productName.isEmpty || expireDate.isEmpty {
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
        if inputBrandTextField.text?.isEmpty == true || inputProductNameTextField.text?.isEmpty == true || inputExpireDateTextField.text?.isEmpty == true {
            setActionButtonEnabled(false)
        } else {
            setActionButtonEnabled(true)
        }
    }
    
    private func setActionButtonEnabled(_ isEnabled: Bool) {
        if isEnabled {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .customButton
        } else {
            completeButton.isEnabled = false
            completeButton.backgroundColor = .unenableButton
        }
    }
}
