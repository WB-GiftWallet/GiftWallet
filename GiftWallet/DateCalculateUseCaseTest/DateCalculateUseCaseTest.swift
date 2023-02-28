//
//  DateCalculateUseCaseTest.swift
//  DateCalculateUseCaseTest
//
//  Created by 서현웅 on 2023/02/28.
//

import XCTest
@testable import GiftWallet

final class DateCalculateUseCaseTest: XCTestCase {

    var sut: DateCalculateUseCase!
    let dateFormatter = DateFormatter()
    
    override func setUpWithError() throws {
        sut = DateCalculateUseCase()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_expireDate가_3일후인_날짜는_3을_return하는지() {
        // given
        let expireDate = Date().addFromTodayDate(3)
        
        // when
        let result = sut.subtractionOftheDays(expireDate: expireDate, today: Date())
        
        // then
        XCTAssertEqual(result, 3)
    }
    
    func test_expireDate가_오늘인_날짜는_0을_return하는지() {
        // given
        let expireDate = Date()
        
        // when
        let result = sut.subtractionOftheDays(expireDate: expireDate, today: Date())
        
        // then
        XCTAssertEqual(result, 0)
    }
    
    func test_expireDate가_7일후인_날짜는_7을_return하는지() {
        // given
        let expireDate = Date().addFromTodayDate(7)
        
        // when
        let result = sut.subtractionOftheDays(expireDate: expireDate, today: Date())
        
        // then
        XCTAssertEqual(result, 7)
    }
    
    func test_expireDate가_7일후인_날짜는_true를_반환하는지() {
        // given
        let expireDate = Date().addFromTodayDate(7)
        
        // when
        let result = sut.checkExpireDateIsSmallerThanSevenDays(expireDate: expireDate)
        
        // then
        XCTAssertTrue(result)
    }
    
    func test_expireDate가_8일후인_날짜는_false를_반환하는지() {
        // given
        let expireDate = Date().addFromTodayDate(8)
        
        // when
        let result = sut.checkExpireDateIsSmallerThanSevenDays(expireDate: expireDate)
        
        // then
        XCTAssertFalse(result)
    }
    
    func test_expireDate가_오늘인_날짜는_true를_반환하는지() {
        // given
        let expireDate = Date()
        
        // when
        let result = sut.checkExpireDateIsSmallerThanSevenDays(expireDate: expireDate)
        
        // then
        XCTAssertTrue(result)
    }
    
    func test_sortOutExpireDate_호출시_observableGifts로_filter되는지() {
        // given
        let expireGifts: Observable<[Gift]> = .init([])
        let gifts: [Gift] = [
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(0)),
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(5)),
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(7)),
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(8))
        ]
        
        // when
        sut.sortOutExpireDate(expireGifts, gifts)
        
        // then
        XCTAssertEqual(expireGifts.value.count, 3)
    }
    
    func test_sortOutRecentDate_호출시_observableGifts로_filter되는지() {
        // given
        let recentGifts: Observable<[Gift]> = .init([])
        let gifts: [Gift] = [
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(0)),
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(5)),
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(7)),
            Gift(image: UIImage(systemName: "cloud")!, category: nil, brandName: nil, productName: nil, memo: nil, expireDate: Date().addFromTodayDate(8))
        ]
        
        // when
        sut.sortOutRecentDate(recentGifts, gifts)
        
        // then
        XCTAssertEqual(recentGifts.value.count, 1)
    }
    
    
}

private extension Date {
    func addFromTodayDate(_ value: Int) -> Date {
        let currentDate = self
        let valueDaysLater = Calendar.current.date(byAdding: .day, value: value, to: currentDate)!
        print("오늘", currentDate)
        print("추가된일자", valueDaysLater)
        
        return valueDaysLater
    }
}
