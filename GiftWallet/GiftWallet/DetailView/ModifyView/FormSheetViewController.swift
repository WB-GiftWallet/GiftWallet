//
//  FormSheetViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/22.
//

import UIKit
import PhotosUI

class FormSheetViewController: UIViewController {
    
    private let viewModel: UpdateViewModel
    var delegate: GiftDidUpdateDelegate?
    
    private let contentView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let defaultLabel = {
        let label = UILabel()
        
        label.text = "수정내역을 선택해주세요"
        label.font = UIFont(style: .bold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let photoImageButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        button.tintColor = .gray
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let photoBlankView = {
        let view = UIView()
        
        view.backgroundColor = .formSheetViewBlankView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let photoImageViewDescriptionLabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .medium, size: 17)
        label.text = "이미지"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pencilImageButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "applepencil"), for: .normal)
        button.tintColor = .gray
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let pencilBlankView = {
        let view = UIView()
        
        view.backgroundColor = .formSheetViewBlankView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let pencilImageViewDescriptionLabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .medium, size: 17)
        label.text = "정보"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pencilStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let photoStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let allButtonHorizontalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.style = .large
        indicator.startAnimating()
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
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
        setupViews()
        setupButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupBlankViewLayer()
    }
    
    private func setupButton() {
        let pencilAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let presentViewController = self.presentingViewController else { return }
            
            self.dismiss(animated: true) {
                let updateGiftInfoViewModel = UpdateViewModel(gift: self.viewModel.gift)
                let updateGiftInfoViewController = UpdateGiftInfoViewController(viewModel: updateGiftInfoViewModel)
                presentViewController.present(updateGiftInfoViewController, animated: true)
            }
        }
        pencilImageButton.addAction(pencilAction, for: .touchUpInside)
        
        let photoAction = UIAction { [weak self] _ in
            self?.activityIndicator.isHidden = false
            self?.presentPHPicekrViewController()
        }
        photoImageButton.addAction(photoAction, for: .touchUpInside)
        
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
        
        pencilBlankView.addSubview(pencilImageButton)
        photoBlankView.addSubview(photoImageButton)
        
        [pencilBlankView, pencilImageViewDescriptionLabel].forEach(pencilStackView.addArrangedSubview(_:))
        [photoBlankView, photoImageViewDescriptionLabel].forEach(photoStackView.addArrangedSubview(_:))
        [pencilStackView, photoStackView].forEach(allButtonHorizontalStackView.addArrangedSubview(_:))
        
        [defaultLabel, allButtonHorizontalStackView ,activityIndicator].forEach(contentView.addSubview(_:))
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            
            photoBlankView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            photoBlankView.heightAnchor.constraint(equalTo: photoBlankView.widthAnchor),
            
            pencilBlankView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            pencilBlankView.heightAnchor.constraint(equalTo: pencilBlankView.widthAnchor),
            
            pencilImageButton.widthAnchor.constraint(equalTo: pencilBlankView.widthAnchor, multiplier: 0.35),
            pencilImageButton.heightAnchor.constraint(equalTo: pencilImageButton.widthAnchor),
            pencilImageButton.centerXAnchor.constraint(equalTo: pencilBlankView.centerXAnchor),
            pencilImageButton.centerYAnchor.constraint(equalTo: pencilBlankView.centerYAnchor),
            
            photoImageButton.widthAnchor.constraint(equalTo: photoBlankView.widthAnchor, multiplier: 0.35),
            photoImageButton.heightAnchor.constraint(equalTo: photoImageButton.widthAnchor),
            photoImageButton.centerXAnchor.constraint(equalTo: photoBlankView.centerXAnchor),
            photoImageButton.centerYAnchor.constraint(equalTo: photoBlankView.centerYAnchor),
            
            defaultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            defaultLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            
            allButtonHorizontalStackView.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 35),
            allButtonHorizontalStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            allButtonHorizontalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupBlankViewLayer() {
        pencilBlankView.layer.cornerRadius = pencilBlankView.frame.width / 2
        photoBlankView.layer.cornerRadius = photoBlankView.frame.width / 2
    }
    
}

// MARK: PHPickerViewController 관련
extension FormSheetViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty {
            self.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true) {
                guard let formattedImage = self.getImage(results: results) else { return }
                var gift = self.viewModel.gift
                gift.image = formattedImage
                self.viewModel.coreDataUpdate()
                self.delegate?.didUpdateGift(updatedGift: gift)
                self.dismiss(animated: true)
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

// MARK: Touch To Dismiss 관련
extension FormSheetViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        
        if !view.subviews.contains(where: { $0.frame.contains(touchLocation) }) {
            self.dismiss(animated: true)
        }
    }
}

// MARK: Gift 정보 수정 시, 호출
protocol GiftDidUpdateDelegate {
//    func tapModifyInfo(gift: Gift)
    func didUpdateGift(updatedGift: Gift)
}
