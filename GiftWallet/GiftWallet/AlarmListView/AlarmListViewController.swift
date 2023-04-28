//
//  AlarmListViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/22.
//

import UIKit

class AlarmListViewController: UIViewController {
    
    private let viewModel: AlarmListViewModel
    
    private let alarmTableView = {
       let tableView = UITableView()
        
        tableView.register(AlarmListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: AlarmListTableHeaderView.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(viewModel: AlarmListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
        setupNavigation()
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupNavigation() {
        title = "알림"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupAttributes() {
        alarmTableView.dataSource = self
        alarmTableView.delegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(alarmTableView)
        
        NSLayoutConstraint.activate([
            alarmTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alarmTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            alarmTableView.topAnchor.constraint(equalTo: view.topAnchor),
            alarmTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension AlarmListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "테스트용"
        cell.detailTextLabel?.text = "테스트디테일라벨"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AlarmListTableHeaderView.reuseIdentifier) as? AlarmListTableHeaderView ?? AlarmListTableHeaderView()
        
        return headerView
    }
    
}

extension AlarmListViewController: UITableViewDelegate {
    
}
