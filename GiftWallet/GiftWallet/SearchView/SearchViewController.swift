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
    private lazy var giftSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchResultsUpdater = self
        searchController.hidesBottomBarWhenPushed = true
        
        searchController.searchBar.placeholder = "브랜드 이름으로 검색하세요!"
        searchController.searchBar.showsSearchResultsButton = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.searchBar.searchTextField.clearsOnBeginEditing = true
        
        return searchController
    }()
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
        
        return tableView
    }()
    
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
        
        setNavigation()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchResultController.tableView.delegate = self
        searchResultController.tableView.dataSource = self
        
        setLayout()
        setupRecommendData()
        bind()
    }
    
    private func setLayout() {
        view.addSubview(scrollView)
        view.addSubview(searchTableView)
        scrollView.addSubview(recommendView)
        
        [searchTableView, recommendView, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
    
    private func setNavigation() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = giftSearchController
    }
    //            view.largeContentImage = UIImage(named: "emptyBoxResize")
    private func setupRecommendData() {
        
        let buttons = [
            recommendView.firstRecommendButton,
            recommendView.secondRecommendButton,
            recommendView.thirdRecommendButton,
            recommendView.fourthRecommendButton,
            recommendView.fifthRecommendButton
        ]
        
        if viewModel.sortedRecommendData.count == 0 {
            return
        } else if viewModel.sortedRecommendData.count <= 5 {
            for (index, value) in viewModel.sortedRecommendData.enumerated() {
                buttons[index].setTitle(value, for: .normal)
                
                //TODO: RecommendView Tag 갯수에 맞게 수정
            }
        }
        
        addTargetButtons()
    }
    
    private func addTargetButtons() {
        [recommendView.firstRecommendButton,
        recommendView.secondRecommendButton,
        recommendView.thirdRecommendButton,
        recommendView.fourthRecommendButton,
         recommendView.fifthRecommendButton].forEach {
            $0.addTarget(nil, action: #selector(tapRecommendButton), for: .touchUpInside)
        }
    }
    
    @objc private func tapRecommendButton(_ sender: UIButton) {
        giftSearchController.searchBar.becomeFirstResponder()
        giftSearchController.searchBar.text = sender.titleLabel?.text
    }
    
    private func bind() {
        viewModel.allGiftData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
                self?.searchResultController.tableView.reloadData()
            }
        }
        
        viewModel.filteringGifts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
                self?.searchResultController.tableView.reloadData()
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
        
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        detailNavigationController.modalPresentationStyle = .overFullScreen
        present(detailNavigationController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
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
