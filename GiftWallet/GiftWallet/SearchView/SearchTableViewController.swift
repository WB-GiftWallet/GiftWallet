//
//  SearchTableViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/01.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    
    let giftSearchController = UISearchController(searchResultsController: nil)
    
    var filteringGifts = [Gift]()
    var allGiftData = [Gift]()
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftSearchController.searchBar.placeholder = "브랜드 이름으로 검색하세요!"
        
        //scopeBar 사용시
        giftSearchController.searchBar.showsScopeBar = true
        
        // Navigation title 숨기지 않게함
        giftSearchController.hidesNavigationBarDuringPresentation = true
        
        //        giftSearchController.hidesBottomBarWhenPushed = false
        
        self.navigationItem.title = "아따 브랜드 검색해유"
        //        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title로 하고싶을 때 추가
        //        self.navigationController?.navigationBar.backgroundColor = . brown
        
        
        self.navigationItem.searchController = giftSearchController
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
        giftSearchController.searchResultsUpdater = self
        
        switch CoreDataManager.shared.fetchData() {
            case .success(let data):
                data.forEach { giftData in
                    guard let bindData = Gift(giftData: giftData) else { return }
                    allGiftData.append(bindData)
                }
            case .failure(let error):
                print(error.localizedDescription)
        }
        
        self.filteringGifts = self.allGiftData.sorted(by: {$0.number < $1.number})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(allGiftData)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteringGifts.count : self.allGiftData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "giftCustomCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        if self.isFiltering {
            cell.giftImageView.image = filteringGifts[indexPath.row].image
            cell.brandNameLabel.text = filteringGifts[indexPath.row].brandName
            cell.productNameLabel.text = filteringGifts[indexPath.row].productName
            cell.expireDateLabel.text = filteringGifts[indexPath.row].expireDate?.setupDateStyleForDisplay()
        } else {
            cell.giftImageView.image = allGiftData[indexPath.row].image
            cell.brandNameLabel.text = allGiftData[indexPath.row].brandName
            cell.productNameLabel.text = allGiftData[indexPath.row].productName
            cell.expireDateLabel.text = allGiftData[indexPath.row].expireDate?.setupDateStyleForDisplay()
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
