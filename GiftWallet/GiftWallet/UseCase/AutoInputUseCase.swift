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
        guard let regex = setupRegularExpression(regexPattern: .yyyyMMdd) else { return }
        let dateStrings = ["달콤함을전하다.", "CONETCON", "STARBUCKS' (스타벅스) 카페 아메리카노", "T", "사용장소 : 스타벅스", "상품수량: 1개", "*사용기한 : 2023.02.12까지", "9999-7088-7125", "2012년 08월03", "2011.11.02", "2233/11/11", "22331111"]
        let trimmedDateStrings = trimmingDataString(dateStrings)

        let results = trimmedDateStrings.filter {
            let isContainNumberInTrimmingDateString = !regex.matches(in: $0,
                                                        options: [],
                                                        range: NSRange(location: 0, length: $0.utf16.count)).isEmpty
            return isContainNumberInTrimmingDateString
        }
        
        let pattern = "[^0-9.]"
        let filtered = results.map { $0.replacingOccurrences(of: pattern, with: "", options: .regularExpression) }
        print(filtered)
        
        let removeDot = filtered.map({ $0.replacingOccurrences(of: ".", with: "") })
        print(removeDot)
        
        let aa = removeDot.filter({ $0.count >= 5 && $0.count <= 8 })
        print(aa)
        
        let resultSet = Set(aa)
        let arrayResult = Array(resultSet)
        print(arrayResult)
        
        let InputFormatter = DateFormatter()
        InputFormatter.dateFormat = "yyyyMMdd"
        
        if let date = InputFormatter.date(from: arrayResult.first!) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            let outputDateString = outputFormatter.string(from: date)
            print(outputDateString)
        }
        
        
        
    }
    
    private func setupRegularExpression(regexPattern: DatePattern) -> NSRegularExpression? {
        var regex: NSRegularExpression?
        
        do {
            regex = try NSRegularExpression(pattern: "\\d+")
            return regex
        } catch {
            print(error.localizedDescription)
        }
        
        return regex
    }
    
    private func trimmingDataString(_ values: [String]) -> [String] {
        return values.map({ $0.replacingOccurrences(of: " ", with: "") })
    }
    /*
     let regex = try! NSRegularExpression(pattern: #"\b\d{4}[./\-년]\d{2}[./\-월 ]\d{2}[^\d]*\b"#)

     var dates: [String] = []

     for str in array {
         let range = NSRange(str.startIndex..<str.endIndex, in: str)
         let matches = regex.matches(in: str, range: range)
         for match in matches {
             let date = (str as NSString).substring(with: match.range)
             dates.append(date)
         }
     }
     */
    
    
    
}

enum DatePattern: CaseIterable {
    case yyyyMMdd
    case yyyyMdd
    case yyMMdd
    case yyMdd
    
    var regexDescription: String {
        switch self {
        case .yyyyMMdd:
            return #"^\d{4}[./\-년]?\d{2}[./\-월 ]?\d{2}[^\d]*$"#
        case .yyyyMdd:
            return #"^\d{4}[./\-년 ]?\d{1,2}[./\-월 ]?\d{2}[^\d]*$"#
        case .yyMMdd:
            return #"^\d{2}[./\-년 ]?\d{2}[./\-월 ]?\d{2}[^\d]*$"#
        case .yyMdd:
            return #"^\d{2}[./\-년 ]?\d{1,2}[./\-월 ]?\d{2}[^\d]*$"#
        }
    }
}
