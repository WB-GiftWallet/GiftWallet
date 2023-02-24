//
//  MainViewModelTests.swift
//  MainViewModelTests
//
//  Created by 서현웅 on 2023/02/24.
//

import XCTest
@testable import GiftWallet

final class MainViewModelTests: XCTestCase {
    var sut: MainViewModel!
    
    override func setUpWithError() throws {
        sut = MainViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: MainviewModel: sortedByCurrentDate() 함수 Logic Test
    func test_만료일까지6일_남은_기프티콘을_추가한다면() {
        
        //given
        
        sut.allGifts = [
            Gift(image: UIImage(systemName: "cloud"), category: .bread, brandName: "스타벅스", productName: "안녕", memo: "메모", expireDate: Date())
        ]
        
        // when
        sut.sortOutInGlobalThread()
//        let promise = expectation(description: "It makes random value")
        // then
        
//        XCTAssertEqual(sut.expireGifts.value.count, 1)
//        XCTAssertEqual(sut.recentGifts.value.count, 0)
//        XCTAssertEqual(sut.unavailableGifts.count, 0)
    }
}

// MARK: Test에서만 활용

private extension Date {
    func addFromTodayDate(_ value: Int) -> Date {
        let currentDate = self
        let valueDaysLater = Calendar.current.date(byAdding: .day, value: value, to: currentDate)!
        return valueDaysLater
    }
}

