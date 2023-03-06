//
//  AutomationUserInputManager.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/03/01.
//

import Foundation

struct AutoInputUseCase {
    
    //MARK: Texts To Brand
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
    func processImageTextsToExpireDate(imageTexts: [String]?) -> String? {
        guard let regex = setupRegularExpression(),
              let imageTexts = imageTexts else { return nil }
        
        let trimmedImageTexts = trimmingImageTexts(imageTexts)
        let filteredTexts = filterWhenImageTextHasNumber(regex, trimmedImageTexts)
        let removeNumberInTexts = removeNumberInFilteredTexts(filteredTexts)
        let removeDotTexts = removeDotInTexts(removeNumberInTexts)
        let filterdByTextCountTexts = filterIsEnoughTextCount(removeDotTexts)
        let removeDuplicatedNumberTexts = removeDuplicatedNumber(filterdByTextCountTexts)
                
        let outputDateString = processInputDateFormatToDisplayingDateFormat(texts: removeDuplicatedNumberTexts)
        
        return outputDateString
    }
    
    private func trimmingImageTexts(_ values: [String]) -> [String] {
        return values.map({ $0.replacingOccurrences(of: " ", with: "") })
    }
    
    private func filterWhenImageTextHasNumber(_ regex: NSRegularExpression,
                                              _ texts: [String]) -> [String] {
        let filteredTexts = texts.filter {
            let isContainNumberInTexts = !regex.matches(in: $0,
                                                        options: [],
                                                        range: NSRange(location: 0,
                                                                       length: $0.utf16.count)).isEmpty
            return isContainNumberInTexts
        }
        return filteredTexts
    }
    
    private func setupRegularExpression() -> NSRegularExpression? {
        var regex: NSRegularExpression?
        
        do {
            regex = try NSRegularExpression(pattern: "\\d+")
            return regex
        } catch {
            print(error.localizedDescription)
        }
        
        return regex
    }
    
    private func removeNumberInFilteredTexts(_ texts: [String]) -> [String] {
        let regexPattern = "[^0-9.]"
        
        let removedNumberInTexts = texts.map {
            $0.replacingOccurrences(of: regexPattern, with: "", options: .regularExpression)
        }
        return removedNumberInTexts
    }
    
    private func removeDotInTexts(_ texts: [String]) -> [String] {
        return texts.map({ $0.replacingOccurrences(of: ".", with: "") })
    }
    
    private func filterIsEnoughTextCount(_ texts: [String]) -> [String] {
        return texts.filter({ $0.count >= 5 && $0.count <= 8 })
    }
    
    private func removeDuplicatedNumber(_ texts: [String]) -> [String] {
        let setTexts = Set(texts)
        return Array(setTexts)
    }
    
    private func processInputDateFormatToDisplayingDateFormat(texts: [String]) -> String? {
        guard let text = texts.first else { return nil }
        var outputString: String?
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = branchOutByTextCount(text: text)
        
        if let date = inputDateFormatter.date(from: text) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy. MM. dd"
            outputString = outputFormatter.string(from: date)
            return outputString
        }
        return outputString
    }
    
    private func branchOutByTextCount(text: String) -> String {
        switch text.count {
        case 5:
            return "yyMdd"
        case 6:
            return "yyMMdd"
        case 7:
            return "yyyyMdd"
        case 8:
            return "yyyyMMdd"
        default:
            return "yyyyMMdd"
        }
    }
}
