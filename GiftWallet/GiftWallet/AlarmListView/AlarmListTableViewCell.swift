//
//  AlarmListTableViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/04/28.
//

import UIKit

class AlarmListTableViewCell: UITableViewCell,ReusableView {
    // title , body, date, id, notiType
    private let typeImageView = {
       let imageView = UIImageView()
        
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let bodyLabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let dateLabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let toggleImageView = {
       let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.down")
        //chevron.forward 로 변해야함
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [typeImageView, titleLabel, bodyLabel, dateLabel, toggleImageView].forEach(contentView.addSubview(_:))
        
        NSLayoutConstraint.activate([
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            typeImageView.heightAnchor.constraint(equalTo: typeImageView.widthAnchor, multiplier: 1),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: toggleImageView.leadingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            toggleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            toggleImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            toggleImageView.heightAnchor.constraint(equalTo: toggleImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    func configureCell(data: AlarmModel) {
        guard let notiType = data.notiType else { return }
        
        typeImageView.image = UIImage(systemName: notiType.alarmImageSymbolsDescription)
        titleLabel.text = data.title
        dateLabel.text = data.date?.description
    }
    
}


/*
 
 enum AlarmType: Int {
     case notification = 0 // 공지
     case couponExpiration // 내부 알람
     case userNotification // UserNotification 알람
 }
 */
