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
    }
    
}

extension AlarmListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension AlarmListViewController: UITableViewDelegate {
    
}
