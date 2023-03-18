//
//  SearchGiftCustomCell.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/01.
//

import UIKit

class CustomCell: UITableViewCell {
    var giftImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "testImageSTARBUCKSSMALL")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var brandNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "임시 텍스트 입니다"
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "임시 텍스트 입니다"
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    var expireDateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "임시 텍스트 입니다"
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        giftImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layoutMargins = .init(top: 3, left: 3, bottom: -3, right: -3)
        let marginGuide = contentView.layoutMarginsGuide
        
        [giftImageView, labelStackView].forEach(contentView.addSubview(_:))
        [brandNameLabel ,productNameLabel, expireDateLabel].forEach(labelStackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            giftImageView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            giftImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            giftImageView.widthAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: 0.3),
            giftImageView.heightAnchor.constraint(equalTo: giftImageView.widthAnchor),
            
            labelStackView.leadingAnchor.constraint(equalTo: giftImageView.trailingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: giftImageView.centerYAnchor)
        ])
    }
    func changeCell(_ giftData: Gift) {
        giftImageView.image = giftData.image
        brandNameLabel.text = giftData.brandName
        productNameLabel.text = giftData.productName
        expireDateLabel.text = giftData.expireDate?.setupDateStyleForDisplay()
    }
    
    func changeGiftImageView(_ image: UIImage) {
        giftImageView.image = image
    }
    func changeBrandNameLabel(_ brandName: String) {
        brandNameLabel.text = brandName
    }
    func changeProductNameLabel(_ productName: String) {
        productNameLabel.text = productName
    }
    func changeExpireDateLabel(_ expireDate: Date) {
        expireDateLabel.text = expireDate.setupDateStyleForDisplay()
    }
}
