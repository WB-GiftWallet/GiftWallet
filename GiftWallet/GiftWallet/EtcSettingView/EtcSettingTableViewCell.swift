//
//  EtcSettingTableViewCell.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import UIKit

class EtcSettingTableViewCell: UITableViewCell, ReusableView {

    var etcCellElementTappedDelegate: EtcCellElementTappedDelegate?
    
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
        
        switchButton.addTarget(self, action: #selector(setupPushSwitchAction(sender:)), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.isHidden = true
        
        return switchButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPushSwitch()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPushSwitch() {
        if let value = UserDefaults.standard.value(forKey: "PushAlarm") as? Bool {
            self.pushSwitch.isOn = value
        }
    }
    
    func configureCell(section: Int, index: Int) {
        switch section {
        case 0:
            settingListLabel.text = Constant.AccountInfo(rawValue: index)?.labelDescription
            statusLabel.text = nil
            setupAttributesAccontInfoCell(index)
        case 1:
            settingListLabel.text = Constant.AuthorizeSetting(rawValue: index)?.labelDescription
            setupAttributesAuthorizeSettingCell(index)
        default:
            break
        }
    }
    
    @objc
    private func setupPushSwitchAction(sender: UISwitch) {
        etcCellElementTappedDelegate?.toggledSwitch(sender: sender, completion: { [weak self] value in
            UserDefaults.standard.setValue(value, forKey: "PushAlarm")
            self?.pushSwitch.setOn(value, animated: true)
        })
    }
    
    private func setupAttributesAccontInfoCell(_ index: Int) {
        if index == 1 {
            self.accessoryType = .none
            self.settingListLabel.textColor = .red
        }
    }
    
    private func setupAttributesAuthorizeSettingCell(_ index: Int) {
        if index == 0 {
            let value = UserDefaults.standard.bool(forKey: "PushAlarm")
            statusLabel.text = value ? "ON" : "OFF"
        }
        
        if index == 0 || index == 1 {
            self.accessoryType = .none
            self.selectionStyle = .none
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

protocol EtcCellElementTappedDelegate {
    func toggledSwitch(sender: UISwitch, completion: @escaping (Bool) -> Void)
}
