//
//  UsageHistoryViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/23.
//

import UIKit

class UsageHistoryViewController: UIViewController {

    let viewModel: UsageHistoryViewModel
    
    let historyTableView = {
       let tableView = UITableView()
        
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    
    init(viewModel: UsageHistoryViewModel) {
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
        historyTableView.dataSource = self
        historyTableView.delegate = self
    }
    
    private func setupNavigation() {
        title = "이용내역"
    }
    
    private func setupViews() {
        
        view.addSubview(historyTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

extension UsageHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier,
                                                        for: indexPath) as? HistoryTableViewCell ?? HistoryTableViewCell()
        
        return cell
    }
    
}

extension UsageHistoryViewController: UITableViewDelegate {
    
}
