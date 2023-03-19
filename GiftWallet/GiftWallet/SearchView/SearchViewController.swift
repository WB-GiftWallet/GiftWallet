//
//  SearchViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/07.
//

import UIKit

final class SearchViewController: UIViewController {
    
    let viewModel = SearchTableViewModel()
    
    private let searchResultController = SearchTableViewController()
    private lazy var giftSearchController = UISearchController(searchResultsController: searchResultController)
    
    private let searchTableView = UITableView()
    private let scrollView = UIScrollView()
    private let recommendView = RecommendView()
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setSearchController()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchResultController.tableView.delegate = self
        searchResultController.tableView.dataSource = self
        
        setLayout()
        setupRecommendData()
        addTargetButtons()
        bind()
    }
    
    private func setLayout() {
        view.addSubview(scrollView)
        view.addSubview(searchTableView)
        scrollView.addSubview(recommendView)
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        recommendView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scrollView.frameLayoutGuide.heightAnchor.constraint(equalTo: recommendView.heightAnchor),
            
            recommendView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            recommendView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            recommendView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            recommendView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            searchTableView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 4),
            searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setSearchController() {
        
        giftSearchController.view.backgroundColor = .systemBackground
        giftSearchController.searchResultsUpdater = self
        giftSearchController.searchBar.placeholder = "브랜드 이름으로 검색하세요!"
        giftSearchController.hidesBottomBarWhenPushed = true
        giftSearchController.searchBar.showsSearchResultsButton = false
        giftSearchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        giftSearchController.searchBar.searchTextField.clearButtonMode = .always
        giftSearchController.searchBar.searchTextField.clearsOnBeginEditing = true
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = giftSearchController
        
        searchTableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
    }
    
    //MARK: ✅ Complete
    private func setupRecommendData() {
        recommendView.firstRecommendButton.setTitle(viewModel.sortedRecommendData[0], for: .normal)
        recommendView.secondRecommendButton.setTitle(viewModel.sortedRecommendData[1], for: .normal)
        recommendView.thirdRecommendButton.setTitle(viewModel.sortedRecommendData[2], for: .normal)
        recommendView.fourthRecommendButton.setTitle(viewModel.sortedRecommendData[3], for: .normal)
        recommendView.fifthRecommendButton.setTitle(viewModel.sortedRecommendData[4], for: .normal)
    }
    
    private func addTargetButtons() {
        recommendView.firstRecommendButton.addTarget(nil, action: #selector(tapRecommendButton), for: .touchUpInside)
        recommendView.secondRecommendButton.addTarget(nil, action: #selector(tapRecommendButton), for: .touchUpInside)
        recommendView.thirdRecommendButton.addTarget(nil, action: #selector(tapRecommendButton), for: .touchUpInside)
        recommendView.fourthRecommendButton.addTarget(nil, action: #selector(tapRecommendButton), for: .touchUpInside)
        recommendView.fifthRecommendButton.addTarget(nil, action: #selector(tapRecommendButton), for: .touchUpInside)
    }
    
    @objc private func tapRecommendButton(_ sender: UIButton) {
        giftSearchController.searchBar.text = sender.titleLabel?.text
        giftSearchController.searchBar.becomeFirstResponder()
    }
    
    private func bind() {
        viewModel.allGiftData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchResultController.tableView.reloadData()
                print("외않돼1")
            }
        }
        
        viewModel.filteringGifts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchResultController.tableView.reloadData()
                print("외않돼2")
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.viewModel.filteringGifts.value.count : self.viewModel.allGiftData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "giftCustomCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        if self.isFiltering {
            cell.changeCell(viewModel.filteringGifts.value[indexPath.row])
        } else {
            cell.changeCell(viewModel.allGiftData.value[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var indexGiftsData: Gift
        
        if self.isFiltering {
            indexGiftsData = viewModel.filteringGifts.value[indexPath.row]
        } else {
            indexGiftsData = viewModel.allGiftData.value[indexPath.row]
        }
        
        let viewmodel = DetailViewModel(gifts: [indexGiftsData])
        let detailViewController = DetailViewController(viewModel: viewmodel)
        
        let naviDV = UINavigationController(rootViewController: detailViewController)
        naviDV.modalPresentationStyle = .overFullScreen
        present(naviDV, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return
    }
    
    //TODO: Height조정 필요
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 7
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHaldler in
            let dataNumber: Int
            
            if self.isFiltering {
                dataNumber = self.viewModel.filteringGifts.value[indexPath.row].number
                self.viewModel.filteringGifts.value.remove(at: indexPath.row)
            } else {
                dataNumber = self.viewModel.allGiftData.value[indexPath.row].number
            }
            
            do {
                try CoreDataManager.shared.deleteDate(id: Int16(dataNumber))
            } catch {
                print(error.localizedDescription)
            }
            
            for (index, data) in self.viewModel.allGiftData.value.enumerated() {
                if data.number == dataNumber {
                    self.viewModel.allGiftData.value.remove(at: index)
                    break
                }
            }
            
            completionHaldler(true)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.viewModel.filteringGifts.value = self.viewModel.allGiftData.value.filter { $0.brandName!.contains(text) }
        
        self.searchResultController.tableView.reloadData()
    }
}
