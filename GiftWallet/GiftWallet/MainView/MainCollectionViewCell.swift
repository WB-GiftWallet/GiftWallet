//
//  MainCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let shadowView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let giftImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let brandLabel = {
       let label = UILabel()
        label.font = UIFont(style: .medium, size: 16)
        return label
    }()
    
    private let productNameLabel = {
        let label = UILabel()
        label.font = UIFont(style: .regular, size: 15)

        return label
    }()
    
    private let expireDateLabel = {
        let label = UILabel()
        label.font = UIFont(style: .regular, size: 14)
        label.textColor = .systemGray

        return label
    }()
    
    private let subLabelVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()

    private let allContentsVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: Gift) {
        giftImageView.image = data.image
        brandLabel.text = data.brandName
        productNameLabel.text = data.productName
        expireDateLabel.text = DateFormatter.convertToDisplayString(date: data.expireDate ?? Date()) // 이거 임시임 수정해야함.
    }
    
    private func setupShadow() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
        shadowView.layer.masksToBounds = false
    }
    
    private func setupViews() {
        contentView.addSubview(shadowView)
        [brandLabel, productNameLabel, expireDateLabel].forEach(subLabelVerticalStackView.addArrangedSubview(_:))
        [giftImageView, subLabelVerticalStackView].forEach(allContentsVerticalStackView.addArrangedSubview(_:))
        contentView.addSubview(allContentsVerticalStackView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: giftImageView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: giftImageView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: giftImageView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: giftImageView.trailingAnchor),
            shadowView.widthAnchor.constraint(equalTo: giftImageView.widthAnchor),
            shadowView.heightAnchor.constraint(equalTo: giftImageView.heightAnchor),
            
            allContentsVerticalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            allContentsVerticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            allContentsVerticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            allContentsVerticalStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    
    
    
}
