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
        tableView.register(AlarmListTableViewCell.self, forCellReuseIdentifier: AlarmListTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
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
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func bind() {
        viewModel.filteredAlarm.bind { alarmModels in
            self.alarmTableView.reloadData()
        }
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
        return viewModel.filteredAlarm.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.reuseIdentifier, for: indexPath) as? AlarmListTableViewCell ?? AlarmListTableViewCell()
        
        cell.configureCell(data: viewModel.filteredAlarm.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AlarmListTableHeaderView.reuseIdentifier) as? AlarmListTableHeaderView ?? AlarmListTableHeaderView()
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let gifts = viewModel.createDetailGiftDatas(indexRow: indexPath.row) else {
            return
        }
        
        let detailViewModel = DetailViewModel(gifts: gifts)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        
        present(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "알림 내역은 수신일로 부터 30일까지 보관됩니다."
    }
}

extension AlarmListViewController: UITableViewDelegate {

}

extension AlarmListViewController: DidSelectedTableViewHeaderDelegate {
    func didTappedMenuButton(type: AlarmType) {
        viewModel.filterAlarm(type: type)
    }
    
    func didTappedMenuButtonInAllData() {
        viewModel.filterAllData()
    }
}
