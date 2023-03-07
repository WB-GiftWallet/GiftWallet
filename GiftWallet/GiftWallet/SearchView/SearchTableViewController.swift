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
        
        fetchGiftCoreData()
        setSearchController()
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
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
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
        
        var indexGiftData: Gift
        
        if self.isFiltering {
            indexGiftData = filteringGifts[indexPath.row]
        } else {
            indexGiftData = allGiftData[indexPath.row]
        }
        
        let detailViewModel = DetailViewModel(gift: indexGiftData)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        
//        detailViewController.changeBrandLabel(name: indexGiftData.brandName)
//        detailViewController.changeProductNameLabel(name: indexGiftData.productName)
//        detailViewController.changeDateDueLabel(date: indexGiftData.expireDate)
//        detailViewController.changeMemoTextField(name: indexGiftData.memo)
//        detailViewController.changeGiftImageView(image: indexGiftData.image)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 6.5
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.filteringGifts = self.allGiftData.filter { $0.brandName!.contains(text) }
        
        self.tableView.reloadData()
    }
}
