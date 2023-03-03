//
//  AutomationUserInputManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import Foundation

struct AutoInputUseCase {
    
    func processImageTextsToBrandNameText(imageTexts: [String]?) -> String? {
        var brandName: String?
        let brandList = BrandList()

        guard let imageTexts = imageTexts else { return nil }
        let trimmingImageTexts = imageTexts.map( { $0.replacingOccurrences(of: " ", with: "") })
        print(trimmingImageTexts)
        
        for list in brandList.lists {
            if trimmingImageTexts.contains(list) {
                brandName = list
            }
        }
        return brandName
    }
    
    //MARK: Texts To Date
    func processImageTextsToExpireDate() {
        if window.BarcodeDetector
    }
    
    
}



/*
 
 1. 사진의 텍스트 [String] 배열을 받아서 브랜드명 String으로 반환해준다.
 
 2. 사진의 유효기간을 받아서 입력해준다.
    - 입력
 
 */
