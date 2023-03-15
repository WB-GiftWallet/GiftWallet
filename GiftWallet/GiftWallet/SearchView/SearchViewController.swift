//
//  SearchViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/07.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchResultController = SearchTableViewController()
    private lazy var giftSearchController = UISearchController(searchResultsController: searchResultController)
    
    private let searchTableView = UITableView()
    private let scrollView = UIScrollView()
    private let recommendView = RecommendView()
    
    private var allGiftData = [Gift]()
    private var filteringGifts = [Gift]()
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        fetchGiftCoreData()
        setSearchController()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchResultController.tableView.delegate = self
        searchResultController.tableView.dataSource = self
        
        setLayout()
        setupRecommendData()
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
    
    private func fetchGiftCoreData() {
        
        switch CoreDataManager.shared.fetchData() {
            case .success(let data):
                data.forEach { giftData in
                    allGiftData.append(giftData)
                }
            case .failure(let error):
                print(error.localizedDescription)
        }
        
        self.filteringGifts = self.allGiftData.sorted(by: {$0.number < $1.number})
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
    
    private func setupRecommendData() {
        var brandCounts = Dictionary<String, Int>()
        
        allGiftData.forEach { data in
            guard let brandName = data.brandName else { return }
            
            if brandCounts[brandName] == nil {
                brandCounts.updateValue(1, forKey: brandName)
            } else if brandCounts[brandName] != nil {
                guard let value = brandCounts[brandName] else { return }
                brandCounts.updateValue(value + 1, forKey: brandName)
            }
        }
        
        let sortedCounts = brandCounts.sorted { $0.1 > $1.1 }
        
        recommendView.firstRecommendButton.setTitle(sortedCounts[0].key, for: .normal)
        recommendView.secondRecommendButton.setTitle(sortedCounts[1].key, for: .normal)
        recommendView.thirdRecommendButton.setTitle(sortedCounts[2].key, for: .normal)
        recommendView.fourthRecommendButton.setTitle(sortedCounts[3].key, for: .normal)
        recommendView.fifthRecommendButton.setTitle(sortedCounts[4].key, for: .normal)
        
        addTargetButtons()
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
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteringGifts.count : self.allGiftData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "giftCustomCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        if self.isFiltering {
            let indexGiftsData = filteringGifts[indexPath.row]
            cell.giftImageView.image = indexGiftsData.image
            cell.brandNameLabel.text = indexGiftsData.brandName
            cell.productNameLabel.text = indexGiftsData.productName
            cell.expireDateLabel.text = indexGiftsData.expireDate?.setupDateStyleForDisplay()
        } else {
            let indexGiftsData = allGiftData[indexPath.row]
            cell.giftImageView.image = indexGiftsData.image
            cell.brandNameLabel.text = indexGiftsData.brandName
            cell.productNameLabel.text = indexGiftsData.productName
            cell.expireDateLabel.text = indexGiftsData.expireDate?.setupDateStyleForDisplay()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var indexGiftsData: Gift
        
        if self.isFiltering {
            indexGiftsData = filteringGifts[indexPath.row]
        } else {
            indexGiftsData = allGiftData[indexPath.row]
        }
        
        let detailViewController = DetailViewController(giftData: indexGiftsData)
        
        detailViewController.changeBrandLabel(name: indexGiftsData.brandName)
        detailViewController.changeProductNameLabel(name: indexGiftsData.productName)
        detailViewController.changeDateDueLabel(date: indexGiftsData.expireDate)
        detailViewController.changeMemoTextField(name: indexGiftsData.memo)
        detailViewController.changeGiftImageView(image: indexGiftsData.image)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 7
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHaldler in
            let dataNumber: Int
            
            if self.isFiltering {
                dataNumber = self.filteringGifts[indexPath.row].number
                self.filteringGifts.remove(at: indexPath.row)
            } else {
                dataNumber = self.allGiftData[indexPath.row].number
            }
            
            do {
                try CoreDataManager.shared.deleteDate(id: Int16(dataNumber))
            } catch {
                print(error.localizedDescription)
            }
            
            for (index, data) in self.allGiftData.enumerated() {
                if data.number == dataNumber {
                    self.allGiftData.remove(at: index)
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
        self.filteringGifts = self.allGiftData.filter { $0.brandName!.contains(text) }
        
        self.searchResultController.tableView.reloadData()
    }
}
