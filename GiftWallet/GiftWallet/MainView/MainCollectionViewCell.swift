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
        
        return imageView
    }()
    
    private let brandLabel = {
       let label = UILabel()
        return label
    }()
    
    private let productNameLabel = {
        let label = UILabel()
        return label
    }()
    
    private let expireDateLabel = {
        let label = UILabel()
        return label
    }()
    
    private let subLabelVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()

    private let allContentsVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
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
        expireDateLabel.text = data.date.description
    }
    
    
    private func setupViews() {
        [productNameLabel, expireDateLabel].forEach(subLabelVerticalStackView.addArrangedSubview(_:))
        [giftImageView, brandLabel, subLabelVerticalStackView].forEach(allContentsVerticalStackView.addArrangedSubview(_:))
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
