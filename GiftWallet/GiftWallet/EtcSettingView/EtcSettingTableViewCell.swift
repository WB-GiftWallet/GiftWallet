//
//  EtcSettingTableViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import UIKit

class EtcSettingTableViewCell: UITableViewCell, ReusableView {
    
    private let settingListLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이용내역"
        
        return label
    }()
    
    private let statusLabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        
    }
    
    private func setupViews() {
        
        NSLayoutConstraint.activate([
            settingListLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            settingListLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        
        
        
    }
    
}
