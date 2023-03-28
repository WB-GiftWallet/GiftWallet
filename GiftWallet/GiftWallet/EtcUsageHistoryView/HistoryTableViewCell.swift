//
//  HistoryTableViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import UIKit

class HistoryTableViewCell: UITableViewCell, ReusableView {
    
    private let productImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let brandLabel = {
        let label = UILabel()
        
        label.textColor = .systemGray
        label.font = .boldSystemFont(ofSize: 12)
        
        return label
    }()
    
    private let productLabel = {
       let label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let statusLabel = {
       let label = UILabel()
        
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private let labelStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        [brandLabel, productLabel, statusLabel].forEach(labelStackView.addArrangedSubview(_:))
        [productImageView, labelStackView].forEach(contentView.addSubview(_:))
        
        NSLayoutConstraint.activate([

            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            labelStackView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor)
        ])
    }
    
    func configureCell(data: Gift) {
        productImageView.image = data.image
        brandLabel.text = data.brandName
        productLabel.text = data.productName
        statusLabel.text = "사용완료"
    }
    
}
    

