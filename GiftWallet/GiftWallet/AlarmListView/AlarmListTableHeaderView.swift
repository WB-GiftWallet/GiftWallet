//
//  AlarmListTableHeaderView.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/04/28.
//

import UIKit

class AlarmListTableHeaderView: UITableViewHeaderFooterView, ReusableView {
    
    private let menuLabel = {
       let label = UILabel()
        
        label.text = "전체"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let flagImageView = {
       let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [menuLabel, flagImageView].forEach(contentView.addSubview(_:))
        
        NSLayoutConstraint.activate([
            menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            menuLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            flagImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.045),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 1),
            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
}
