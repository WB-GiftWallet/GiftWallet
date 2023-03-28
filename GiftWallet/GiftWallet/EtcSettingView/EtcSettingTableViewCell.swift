//
//  EtcSettingTableViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import UIKit

class EtcSettingTableViewCell: UITableViewCell, ReusableView {
    var senderStatus: Observable<Bool> = .init(true)
    
    var eightCompletion: (Bool) -> Void = {_ in }
    
    func check(completion: @escaping (Bool) -> Void) {
        print("AA")
    }
    
    let settingListLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이용내역"
        
        return label
    }()
    
    let statusLabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var pushSwitch = {
        let switchButton = UISwitch()
        
        switchButton.isOn = true
//        switchButton.setOn(true, animated: true)
        switchButton.addTarget(self, action: #selector(setupPushSwitchAction(sender:)), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.isHidden = true
        
        return switchButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(section: Int, index: Int) {
        switch section {
        case 0:
            settingListLabel.text = Constant.AccountInfo(rawValue: index)?.labelDescription
            statusLabel.text = nil
        case 1:
            settingListLabel.text = Constant.AuthorizeSetting(rawValue: index)?.labelDescription
            setupAttributes(index)
        default:
            break
        }
    }
    
    @objc
    private func setupPushSwitchAction(sender: UISwitch) {
        senderStatus.value.toggle()
    }
    
    private func setupAttributes(_ index: Int) {
        if index == 0 || index == 1 {
            self.accessoryType = .none
        }
        if index == 1 {
            pushSwitch.isHidden = false
        }
    }
    
    private func setupViews() {
        
        [settingListLabel, statusLabel, pushSwitch].forEach(contentView.addSubview(_:))
        
        NSLayoutConstraint.activate([
            settingListLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            settingListLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            pushSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pushSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
}

