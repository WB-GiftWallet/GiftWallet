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
        
        imageView.image = UIImage(named: "testImageEDIYA")
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let brandLabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let productLabel = {
       let label = UILabel()
        
        return label
    }()
    
    private let statusLabel = {
       let label = UILabel()
        
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
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
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
    

