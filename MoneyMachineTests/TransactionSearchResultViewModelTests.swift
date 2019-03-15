//
//  TransactionSearchResultViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionSearchResultViewModelTests: XCTestCase {
    
    var fakeTransaction: FakeTransaction!
    
    override func setUp() {
        fakeTransaction = FakeTransaction(context: FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    }
    
    // Test TransactionSearchResultViewModel
    func testNumberOfRows() {
        // Given
        let subject = TransactionSearchResultViewModel([fakeTransaction])
        
        // When
        let numberOfRows = subject.numberOfRows
        
        // Then
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testResultViewCellModel() {
        // Given
        let subject = TransactionSearchResultViewModel([fakeTransaction])
        
        // When
        let resultCellViewModel = subject.transactionResultCellViewModel(for: 0)
        
        // Then
        XCTAssertNotNil(resultCellViewModel)
    }

    // Test TransactionSearchResultCellViewModel
    func testCorrectPropertyValues() {
        // Given
        let fakeUser = FakeUser()
        fakeUser.testId = "001"
        let fakeTag = FakeTag()
        fakeTag.testName = "Other"
        fakeTransaction.user = fakeUser
        fakeTransaction.tag = fakeTag
        fakeTransaction.amount = 100.00
        fakeTransaction.note = "test note"
        let today = Date()
        fakeTransaction.date = today
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let expectedDateString = "\(dateFormatter.string(from: today))"
        
        // When
        let subject = TransactionSearchResultCellViewModel(transaction: fakeTransaction)
        
        // Then
        XCTAssertEqual(subject.userId, "001")
        XCTAssertEqual(subject.amount, "$100.00")
        XCTAssertEqual(subject.tagName, "Other")
        XCTAssertEqual(subject.description, "test note")
        XCTAssertEqual(subject.date, expectedDateString)
    }

    func testPropertyDefaultValues() {
        // Given, When
        let subject = TransactionSearchResultCellViewModel(transaction: fakeTransaction)
        
        // Then
        XCTAssertEqual(subject.userId, "")
        XCTAssertEqual(subject.amount, "$0.00")
        XCTAssertEqual(subject.tagName, "")
        XCTAssertEqual(subject.description, "")
        XCTAssertEqual(subject.date, "")
    }

}
