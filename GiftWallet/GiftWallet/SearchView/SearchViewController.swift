//
//  SearchViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/07.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let giftSearchController = UISearchController(searchResultsController: nil)
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
        
        fetchGiftCoreData()
        setSearchController()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        setLayout()
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
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            scrollView.frameLayoutGuide.heightAnchor.constraint(equalTo: recommendView.heightAnchor),
            
            recommendView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            recommendView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            recommendView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            recommendView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            searchTableView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
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
        
        giftSearchController.searchResultsUpdater = self
        
        giftSearchController.searchBar.placeholder = "브랜드 이름으로 검색하세요!"
        giftSearchController.hidesBottomBarWhenPushed = true
        giftSearchController.searchBar.showsSearchResultsButton = true
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = giftSearchController
        
        searchTableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
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
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.filteringGifts = self.allGiftData.filter { $0.brandName!.contains(text) }
        
        self.searchTableView.reloadData()
    }
}
