//
//  PagingCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/08.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        return scrollView
    }()
    
    private let containterView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .bold, size: 25)
        
        return label
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .medium, size: 20)
        
        return label
    }()
    
    private let expireDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(style: .light, size: 19)
        
        return label
    }()
    
    private let labelVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let memoTextField: CustomTextField = {
        let textField = CustomTextField(frame: .zero)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let selectedButton: CustomButton = {
        let button = CustomButton()
        
        button.setTitle("사용 완료", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        memoTextField.setupTextFieldBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sampleConfigure() {
        brandLabel.text = "안녕"
        productNameLabel.text = "프로덕네임"
        expireDateLabel.text = "안녕라벨"
        giftImageView.image = UIImage(named: "testImageEDIYA")
        calculateImageViewSize()
    }
    
    private func setupViews() {
        [brandLabel, productNameLabel, expireDateLabel].forEach(labelVerticalStackView.addArrangedSubview(_:))
        
        scrollView.addSubview(containterView)
        [labelVerticalStackView, memoTextField, selectedButton, giftImageView].forEach(containterView.addSubview(_:))
        contentView.addSubview(scrollView)
        
        let containerViewHeightConstraint = containterView.heightAnchor.constraint(equalTo: giftImageView.heightAnchor, multiplier: 1.3)
            containerViewHeightConstraint.priority = .defaultHigh
        
        let contentLayoutGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containterView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            containterView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            containterView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            containterView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            containterView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerViewHeightConstraint,
            
            labelVerticalStackView.topAnchor.constraint(equalTo: containterView.safeAreaLayoutGuide.topAnchor, constant: 15),
            labelVerticalStackView.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 15),
            labelVerticalStackView.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -15),
            
            memoTextField.topAnchor.constraint(equalTo: labelVerticalStackView.bottomAnchor, constant: 10),
            memoTextField.leadingAnchor.constraint(equalTo: containterView.leadingAnchor, constant: 15),
            memoTextField.trailingAnchor.constraint(equalTo: containterView.trailingAnchor, constant: -15),
            
            selectedButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 20),
            selectedButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.05),
            selectedButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            
            giftImageView.topAnchor.constraint(equalTo: selectedButton.bottomAnchor, constant: 20),
            giftImageView.leadingAnchor.constraint(equalTo: containterView.leadingAnchor),
            giftImageView.trailingAnchor.constraint(equalTo: containterView.trailingAnchor),
            giftImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func calculateImageViewSize() {
        containterView.layoutIfNeeded()
        guard let image = giftImageView.image else { return }
        let imageAspectRatio = image.size.height / image.size.width
        let newImageViewHeight = containterView.frame.width * imageAspectRatio
        
        giftImageView.heightAnchor.constraint(equalToConstant: newImageViewHeight).isActive = true
    }
}
