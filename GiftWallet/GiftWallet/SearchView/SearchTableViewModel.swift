//
//  SearchTableViewModel.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/03.
//

import Foundation

class SearchTableViewModel {
    
    var allGiftData: Observable<[Gift]>
    var filteringGifts: Observable<[Gift]> = .init([])
    
    var sortedRecommendData = [String]()
    
    init(allGiftData: Observable<[Gift]>) {
        self.allGiftData = allGiftData
        fetchGiftCoreData()
        setupRecommendData()
    }
    
    //MARK: init Method
    private func fetchGiftCoreData() {

        // MARK: 수정
//        switch CoreDataManager.shared.fetchData() {
//            case .success(let data):
//                allGiftData.value = data
//            case .failure(let error):
//                print(error.localizedDescription)
//        }
        
        sortFilteringGifts()
    }
    
    private func sortFilteringGifts() {
        filteringGifts.value = allGiftData.value.sorted(by: {$0.number < $1.number})
    }
    
    private func setupRecommendData() {
        var brandCounts = Dictionary<String, Int>()
        
        allGiftData.value.forEach { data in
            guard let brandName = data.brandName else { return }
            
            if brandCounts[brandName] == nil {
                brandCounts.updateValue(1, forKey: brandName)
            } else if brandCounts[brandName] != nil {
                guard let value = brandCounts[brandName] else { return }
                brandCounts.updateValue(value + 1, forKey: brandName)
            }
        }
        
        let sortedBrandsNameForDescending = brandCounts.sorted { $0.1 > $1.1 }
        sortedRecommendData = sortedBrandsNameForDescending.map { $0.key }
    }
}
