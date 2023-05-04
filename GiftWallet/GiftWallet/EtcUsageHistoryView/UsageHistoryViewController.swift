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
        title = "이용내역"
        navigationController?.navigationBar.tintColor = .black
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "기간만료"
        case 1:
            return "사용완료"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.expiredGifts.count
        case 1:
            return viewModel.unUesableGifts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier, for: indexPath) as? HistoryTableViewCell ?? HistoryTableViewCell()
        
        switch indexPath.section {
        case 0:
            cell.configureCell(data: viewModel.expiredGifts[indexPath.row], section: indexPath.section)
        case 1:
            cell.configureCell(data: viewModel.unUesableGifts[indexPath.row], section: indexPath.section)
        default:
            break
        }
        return cell
    }
}

extension UsageHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
