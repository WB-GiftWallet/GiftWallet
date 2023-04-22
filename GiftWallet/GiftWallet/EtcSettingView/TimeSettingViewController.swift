//
//  timeSettingViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/04/22.
//

import UIKit

class TimeSettingViewController: UIViewController {

    private let times = ["오전 12시", "오전 1시", "오전 2시", "오전 3시", "오전 4시", "오전 5시", "오전 6시", "오전 7시", "오전 8시", "오전 9시", "오전 10시", "오전 11시", "오후 12시", "오후 1시", "오후 2시", "오후 3시", "오후 4시", "오후 5시", "오후 6시", "오후 7시", "오후 8시", "오후 9시", "오후 10시", "오후 11시"]
    private var selectedIndexPath: Int?
    
    private let tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValueFromUserDefault()
        setupNavigation()
        setupAttributes()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadSeletedTimeToUserDefault()
    }
    
    private func setupValueFromUserDefault() {
        let settedValue = UserDefaults.standard.integer(forKey: "NotificationHour")
        selectedIndexPath = settedValue
    }
    
    private func loadSeletedTimeToUserDefault() {
        if let selectedIndexPath = selectedIndexPath {
            UserDefaults.standard.setValue(selectedIndexPath, forKey: "NotificationHour")
        }
    }

    private func setupAttributes() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigation() {
        title = "알림시각"
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TimeSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = times[indexPath.row]
        
        if let selectedIndexPath = selectedIndexPath {
            let settedIndex = IndexPath(row: selectedIndexPath, section: 0)
            
            if settedIndex == indexPath {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
            
        }
        return cell
    }
}

extension TimeSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedIndexPath {
            let settedIndexPath = IndexPath(row: index, section: 0)
            
            tableView.cellForRow(at: settedIndexPath)?.accessoryType = .none
        }

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndexPath = indexPath.row

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
