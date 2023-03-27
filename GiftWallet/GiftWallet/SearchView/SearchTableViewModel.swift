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
        
        sortFilteringGifts()
        setupRecommendData()
    }
    
    //MARK: Initail Function
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
    
    
    
    func filterGiftDataWhenUpdate(_ text: String) {
        filteringGifts.value = allGiftData.value.filter { $0.brandName!.contains(text) }
    }
}
