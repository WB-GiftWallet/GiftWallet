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
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
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
        setupViews()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadProfileViewAttributes()
    }
    
    private func configureUserProfile() {
        if viewModel.currentUser == nil {
            nameLabel.text = "로그인 필요"
            idLabel.text = "표시할 유저정보가 없습니다."
        }
        
        guard let userName = viewModel.userName,
              let userEmamil = viewModel.userEmail else { return }
        
        if userEmamil.contains("@privaterelay.appleid.com") {
            nameLabel.text = userName
            idLabel.text = "\(userName)@private.appleID.com"
            
        } else {
            nameLabel.text = userName
            idLabel.text = userEmamil
        }
    }
    
    private func reloadProfileViewAttributes() {
        setupButtonAttributes()
        configureUserProfile()
    }
    
    private func setupButtonAttributes() {
        let titleLabel = viewModel.currentUser == nil ? "로그인" : "로그아웃"
        let color = viewModel.currentUser == nil ? UIColor.systemBlue : UIColor.red
        let layerColor = color.cgColor
        
        logoutButton.setTitle(titleLabel, for: .normal)
        logoutButton.setTitleColor(color, for: .normal)
        logoutButton.layer.borderColor = layerColor
    }
    
    private func setupButton() {
        let logoutAction = UIAction { _ in
            self.showSignOutAlert()
        }
        logoutButton.addAction(logoutAction, for: .touchUpInside)
    }
    
    private func setupTableViewAttributes() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
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
            
            logoutButton.trailingAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.trailingAnchor, constant: -20),
            logoutButton.widthAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.widthAnchor, multiplier: 0.15),
            logoutButton.heightAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.heightAnchor, multiplier: 0.2),
            logoutButton.centerYAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.centerYAnchor),
            
            settingTableView.topAnchor.constraint(equalTo: simpleProfileHeaderHorizontalStackView.bottomAnchor, constant: 20),
            settingTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: TableViewDataSource 관련
extension EtcSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.setupNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: EtcSettingTableViewCell.reuseIdentifier,
                                                        for: indexPath) as? EtcSettingTableViewCell ?? EtcSettingTableViewCell()
        cell.etcCellElementTappedDelegate = self
        cell.accessoryType = .disclosureIndicator
        cell.configureCell(section: indexPath.section, index: indexPath.row)
        
        return cell
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

// MARK: TableViewDelegate 관련
extension EtcSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            usageHistoryViewSceneConversion()
        } else if indexPath.section == 0, indexPath.row == 1 {
            showDeleteUserAlert()
        } else if indexPath.section == 1, indexPath.row == 2 {
            timeSettingViewSceneConversion()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func usageHistoryViewSceneConversion() {
        let UsageHistoryViewModel = UsageHistoryViewModel()
        let usageHistoryViewController = UsageHistoryViewController(viewModel: UsageHistoryViewModel)
        navigationController?.pushViewController(usageHistoryViewController, animated: true)
    }
    
    private func timeSettingViewSceneConversion() {
        let timeSeetingViewController = TimeSettingViewController()
        navigationController?.pushViewController(timeSeetingViewController, animated: true)
    }
    
    private func loginViewSceneConversion() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.delegate = self
        loginViewController.modalPresentationStyle = .overFullScreen
        present(loginViewController, animated: true)
    }
}

// MARK: Cell의 인터랙션을 관리하는 EtcCellElementTappedDelegate
extension EtcSettingViewController: EtcCellElementTappedDelegate {
    func toggledSwitch(sender: UISwitch, completion: @escaping (Bool) -> Void) {
        showToggleAlert(sender: sender, completion: completion)
    }
    
    private func showToggleAlert(sender: UISwitch, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: "푸시알림 설정을 변경할까요?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            let cell = self.settingTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EtcSettingTableViewCell
            
            cell?.statusLabel.text = sender.isOn ? "ON" : "OFF"
            completion(sender.isOn)
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            let cell = self.settingTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EtcSettingTableViewCell
            cell?.statusLabel.text = !sender.isOn ? "ON" : "OFF"
            completion(!sender.isOn)
        }
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
    
}

//MARK: Alert 관련
extension EtcSettingViewController {
    private func showSignOutAlert() {
        let title = viewModel.currentUser == nil ? "로그인이 필요합니다." : nil
        let message = viewModel.currentUser == nil ? "로그인 할까요?" : "로그아웃 합니다."
        let style: UIAlertController.Style = viewModel.currentUser == nil ? .alert : .actionSheet
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style
        )
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            if self.viewModel.currentUser == nil {
                self.loginViewSceneConversion()
            } else {
                self.viewModel.signOut()
                self.reloadProfileViewAttributes()
            }
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
    
    
    private func showDeleteUserAlert() {
        let title = viewModel.currentUser == nil ? "로그인이 필요합니다." : nil
        let message = viewModel.currentUser == nil ? "로그인 할까요?" : "회원탈퇴하고 모든 데이터를 제거합니다."
        let style: UIAlertController.Style = viewModel.currentUser == nil ? .alert : .actionSheet
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "네", style: .destructive) { _ in
            if self.viewModel.currentUser == nil {
                self.loginViewSceneConversion()
            } else {
                self.viewModel.deleteUser {
                    self.reloadProfileViewAttributes()
                }
            }
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        [okAction, noAction].forEach(alertController.addAction(_:))
        present(alertController, animated: true)
    }
}

//MARK: 로그인완료를 알리는 DidFetchGiftDelegate 관련
extension EtcSettingViewController: DidFetchGiftDelegate {
    func finishedFetch() {
        reloadProfileViewAttributes()
    }
}
