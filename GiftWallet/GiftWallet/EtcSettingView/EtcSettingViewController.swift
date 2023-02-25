//
//  EtcSettingViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/25.
//

import UIKit

class EtcSettingViewController: UIViewController {

    let viewModel: EtcSettingViewModel

    private let nameLabel = {
       let label = UILabel()
        
        label.text = "서현웅"
        label.font = .boldSystemFont(ofSize: 25)
        
        return label
    }()
    
    private let idLabel = {
       let label = UILabel()
        
        label.text = "workplayhard1@naver.com"
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private let logoutButton = {
        let button = UIButton()
        
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let profileVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let simpleProfileHeaderHorizontalStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private let settingTableView = {
       let tableView = UITableView()
        
        return tableView
    }()
    
    
    init(viewModel: EtcSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
    }
    
    private func setupNavigation() {
    }
    
    
    private func setupViews() {
        [nameLabel, idLabel].forEach(profileVerticalStackView.addArrangedSubview(_:))
        [profileVerticalStackView, logoutButton].forEach(simpleProfileHeaderHorizontalStackView.addArrangedSubview(_:))
        
        [simpleProfileHeaderHorizontalStackView, settingTableView].forEach(view.addSubview(_:))
        
        let safeArea = view.safeAreaLayoutGuide
        
        simpleProfileHeaderHorizontalStackView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            
            logoutButton.widthAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.widthAnchor, multiplier: 0.2),
            logoutButton.heightAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.heightAnchor, multiplier: 0.3),
            
            simpleProfileHeaderHorizontalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            simpleProfileHeaderHorizontalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            simpleProfileHeaderHorizontalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            simpleProfileHeaderHorizontalStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.15),
            
            
            settingTableView.topAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.bottomAnchor, constant: 20),
            settingTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    

}
