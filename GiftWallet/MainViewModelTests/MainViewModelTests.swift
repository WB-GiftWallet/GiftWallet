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
    
    // MARK: MainviewModel: sortOutAsTodaysDate() 함수 Logic Test
    func test_만료일까지0일_남은_기프티콘을_추가한다면_expireGifts_에추가될지() {
        let promise = expectation(description: "It makes random value")
        
        //given :- in 만료일까지 0일 남은 기프티콘
        sut.allGifts = [
            Gift(image: UIImage(systemName: "cloud")!, category: .bread, brandName: "스타벅스", productName: "안녕", memo: "메모", expireDate: Date())
        ]
        
        // when
        sut.sortOutInGlobalThread()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.checkAsyncFunction())
            promise.fulfill()
        }
        
        // then
        
        wait(for: [promise], timeout: 3.0)
        XCTAssertEqual(sut.expireGifts.value.count, 1)
        XCTAssertEqual(sut.recentGifts.value.count, 0)
    }
     
    func test_만료일까지3일_남은_기프티콘을_추가한다면_expireGifts_에추가될지() {
        let promise = expectation(description: "It makes random value")
        
        //given :- in 만료일까지 3일 남은 기프티콘
        
        sut.allGifts = [
            Gift(image: UIImage(systemName: "cloud")!, category: .bread, brandName: "스타벅스", productName: "안녕", memo: "메모", expireDate: Date().addFromTodayDate(3))
        ]
        
        // when
        sut.sortOutInGlobalThread()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.checkAsyncFunction())
            promise.fulfill()
        }
        
        // then
        wait(for: [promise], timeout: 3.0)
        XCTAssertEqual(sut.expireGifts.value.count, 1)
        XCTAssertEqual(sut.recentGifts.value.count, 0)
    }
    
    func test_만료일까지7일_남은_기프티콘을_추가한다면_expireGifts에_추가될지() {
        let promise = expectation(description: "It makes random value")
        
        //given :- in 만료일까지 7일 남은 기프티콘
        sut.allGifts = [
            Gift(image: UIImage(systemName: "cloud")!, category: .bread, brandName: "스타벅스", productName: "안녕", memo: "메모", expireDate: Date())
        ]
        
        // when
        sut.sortOutInGlobalThread()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.checkAsyncFunction())
            promise.fulfill()
        }

        // then
        wait(for: [promise], timeout: 3.0)
        XCTAssertEqual(sut.expireGifts.value.count, 1)
        XCTAssertEqual(sut.recentGifts.value.count, 0)
    }
    
    func test_만료일까지8일_남은_기프티콘을_추가한다면_recentGifts에_추가될지() {
        let promise = expectation(description: "It makes random value")
        
        //given
        
        sut.allGifts = [
            Gift(image: UIImage(systemName: "cloud")!, category: .bread, brandName: "스타벅스", productName: "안녕", memo: "메모", expireDate: Date().addFromTodayDate(8))
        ]
        
        // when
        sut.sortOutInGlobalThread()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.checkAsyncFunction())
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3.0)
        XCTAssertEqual(sut.expireGifts.value.count, 1)
        XCTAssertEqual(sut.recentGifts.value.count, 0)
        XCTAssertEqual(sut.unavailableGifts.count, 0)
    }
}

extension MainViewModelTests {
    private func checkAsyncFunction() -> Bool {
        if sut.expireGifts.value.isEmpty == false ||
            sut.recentGifts.value.isEmpty == false ||
            sut.unavailableGifts.isEmpty == false {
            
            return true
        }
        return false
    }
}


// MARK: Test에서만 활용

private extension Date {
    func addFromTodayDate(_ value: Int) -> Date {
        let currentDate = self
        let valueDaysLater = Calendar.current.date(byAdding: .day, value: value, to: currentDate)!
        print("오늘:", currentDate)
        print("타겟일자:" ,valueDaysLater)
        
        let dateConents = Calendar.current.dateComponents([.day], from: currentDate, to: valueDaysLater)
        print("날짜차이:", dateConents.day)
        
        return valueDaysLater
    }
}

