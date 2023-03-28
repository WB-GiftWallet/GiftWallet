//
//  UsageHistoryViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/27.
//

import UIKit

class UsageHistoryViewController: UIViewController {

    let viewModel: UsageHistoryViewModel
    
    private let historyTableView = {
        let tableView = UITableView()
        
        tableView.register(HistoryTableViewCell.self,
                           forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
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
        
        setupTableViewAttributes()
        setupNavigation()
        setupViews()
    }
    
    private func setupNavigation() {
        title = "주문·배송"
    }
    
    private func setupTableViewAttributes() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(historyTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension UsageHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.unavailableGifts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.unavailableGifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier, for: indexPath) as? HistoryTableViewCell ?? HistoryTableViewCell()
        
        cell.configureCell(data: viewModel.unavailableGifts[indexPath.row])
        
        return cell
    }
}

extension UsageHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}
