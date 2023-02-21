//
//  MainCollectionViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let giftImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let brandLabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let productNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)

        return label
    }()
    
    private let expireDateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: Gifts) {
        giftImageView.image = data.image
        brandLabel.text = data.brandName
        productNameLabel.text = data.product
        expireDateLabel.text = DateFormatter.convertToDisplayString(date: data.date)
    }
    
    private func setupViews() {
        [brandLabel, productNameLabel, expireDateLabel].forEach(subLabelVerticalStackView.addArrangedSubview(_:))
        [giftImageView, subLabelVerticalStackView].forEach(allContentsVerticalStackView.addArrangedSubview(_:))
        contentView.addSubview(allContentsVerticalStackView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            allContentsVerticalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            allContentsVerticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            allContentsVerticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            allContentsVerticalStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    
    
    
}
