//
//  SearchTableViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/01.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    
    private let giftSearchController = UISearchController(searchResultsController: nil)
    
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
        
        setSearchController()
    }
    
    private func setSearchController() {
        
        giftSearchController.searchBar.placeholder = "브랜드 이름으로 검색하세요!"
        //scopeBar 사용시
        giftSearchController.searchBar.showsScopeBar = true
        
        // Navigation title 숨기지 않게함
        giftSearchController.hidesNavigationBarDuringPresentation = true
        
        giftSearchController.hidesBottomBarWhenPushed = true
        
        giftSearchController.searchBar.showsSearchResultsButton = true
        //        self.navigationItem.title = "검색title"
        
        // SearchBar 항상 보이도록 설정
        self.navigationItem.hidesSearchBarWhenScrolling = false
        // Large title로 하고싶을 때 추가
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = giftSearchController
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
        giftSearchController.searchResultsUpdater = self
        
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
}

//MARK: TableView Method
extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteringGifts.count : self.allGiftData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.filteringGifts = self.allGiftData.filter { $0.brandName!.contains(text) }
        
        self.tableView.reloadData()
    }
}
