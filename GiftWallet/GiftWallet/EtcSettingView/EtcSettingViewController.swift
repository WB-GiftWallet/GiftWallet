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
        
        label.text = "이름오류"
        label.font = UIFont(style: .bold, size: 25)
        
        return label
    }()
    
    private let idLabel = {
       let label = UILabel()
        
        label.text = "아이디오류"
        label.font = UIFont(style: .medium, size: 15)
        
        return label
    }()
    
    private let logoutButton = {
        let button = UIButton()
        
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = UIFont(style: .regular, size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let profileVerticalStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let simpleProfileHeaderHorizontalStackView = {
        let stackView = UIView()
    
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private let settingTableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.register(EtcSettingTableViewCell.self,
                           forCellReuseIdentifier: EtcSettingTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
        setupTableViewAttributes()
        setupNavigation()
        setupViews()
        configureUserProfile()
        setupButton()
    }
    
    private func configureUserProfile() {
        guard let userName = viewModel.userName,
              let userEmamil = viewModel.userEmail else { return }
        
        nameLabel.text = userName
        idLabel.text = userEmamil
    }
    
    
    private func setupButton() {
        let logoutAction = UIAction { _ in
            self.showAlert()
        }
        logoutButton.addAction(logoutAction, for: .touchUpInside)
    }
    
    private func setupTableViewAttributes() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    private func setupNavigation() {
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: nil, message: "로그아웃 합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            self.viewModel.signOut()
            self.tabBarController?.selectedIndex = 0
            let loginViewModel = LoginViewModel()
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: true)
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
    
    private func setupViews() {
        [nameLabel, idLabel].forEach(profileVerticalStackView.addArrangedSubview(_:))
        [profileVerticalStackView, logoutButton].forEach(simpleProfileHeaderHorizontalStackView.addSubview(_:))
        
        [simpleProfileHeaderHorizontalStackView, settingTableView].forEach(view.addSubview(_:))
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .secondarySystemBackground
        simpleProfileHeaderHorizontalStackView.backgroundColor = .white
        simpleProfileHeaderHorizontalStackView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            simpleProfileHeaderHorizontalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            simpleProfileHeaderHorizontalStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            simpleProfileHeaderHorizontalStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            simpleProfileHeaderHorizontalStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.15),
            
            profileVerticalStackView.leadingAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.leadingAnchor, constant: 10),
            profileVerticalStackView.centerYAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.centerYAnchor),
            
            logoutButton.trailingAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.trailingAnchor, constant: -10),
            logoutButton.widthAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.widthAnchor, multiplier: 0.2),
            logoutButton.heightAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.heightAnchor, multiplier: 0.3),
            logoutButton.centerYAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.centerYAnchor),
            
            settingTableView.topAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.bottomAnchor, constant: 20),
            settingTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension EtcSettingViewController: UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.setupNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: EtcSettingTableViewCell.reuseIdentifier,
                                                        for: indexPath) as? EtcSettingTableViewCell ?? EtcSettingTableViewCell()
        cell.accessoryType = .disclosureIndicator
        bind(cell: cell)
        cell.configureCell(section: indexPath.section, index: indexPath.row)
        
        return cell
    }
    
    private func bind(cell: EtcSettingTableViewCell) {
        cell.senderStatus.bind { status in
            let reloadTargetIndex = IndexPath(row: 0, section: 1)
            let targetCell = self.settingTableView.cellForRow(at: reloadTargetIndex) as? EtcSettingTableViewCell ?? EtcSettingTableViewCell()
            switch status {
            case true:
                targetCell.statusLabel.text = "ON"
            case false:
                targetCell.statusLabel.text = "OFF"
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionNumber
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.setupSectionHeader(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 15
    }
    
}

extension EtcSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            sceneConversion()
        }
    }
    
    private func sceneConversion() {
        let UsageHistoryViewModel = UsageHistoryViewModel()
        let usageHistoryViewController = UsageHistoryViewController(viewModel: UsageHistoryViewModel)
        navigationController?.pushViewController(usageHistoryViewController, animated: true)
    }
}
