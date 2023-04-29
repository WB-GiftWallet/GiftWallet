//
//  AlarmListTableHeaderView.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/04/28.
//

import UIKit

class AlarmListTableHeaderView: UITableViewHeaderFooterView, ReusableView {
    
    var delegate: DidSelectedTableViewHeaderDelegate?
    
    private let menuLabel = {
       let label = UILabel()
        
        label.text = "전체"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let flagImageButton: ExpandedTouchAreaButton = {
       let button = ExpandedTouchAreaButton()
        
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.tintColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupPopUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPopUpButton() {
        flagImageButton.menu = UIMenu(children: [
            UIAction(title: "전체", image: UIImage(systemName: "list.bullet.clipboard"), handler: { _ in
                self.menuLabel.text = "전체"
                self.delegate?.didTappedMenuButtonInAllData()
            }),
            UIAction(title: "공지", image: UIImage(systemName: "speaker.wave.3"), handler: { _ in
                self.menuLabel.text = "공지"
                self.delegate?.didTappedMenuButton(type: .notification)
            }),
            UIAction(title: "쿠폰 알림", image: UIImage(systemName: "bell"), handler: { _ in
                self.menuLabel.text = "쿠폰 알림"
                self.delegate?.didTappedMenuButton(type: .couponExpiration)
            }),
            UIAction(title: "시스템 알림", image: UIImage(systemName: "network"), handler: { _ in
                self.menuLabel.text = "시스템 알림"
                self.delegate?.didTappedMenuButton(type: .userNotification)
            }),
        ])

        flagImageButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupViews() {
        [menuLabel, flagImageButton].forEach(contentView.addSubview(_:))
        
        NSLayoutConstraint.activate([
            menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            menuLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            flagImageButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.045),
            flagImageButton.heightAnchor.constraint(equalTo: flagImageButton.widthAnchor, multiplier: 1),
            flagImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            flagImageButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

protocol DidSelectedTableViewHeaderDelegate {
    func didTappedMenuButton(type: AlarmType)
    func didTappedMenuButtonInAllData()
}
