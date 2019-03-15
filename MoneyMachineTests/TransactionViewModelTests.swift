//
//  TransactionViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionViewModelTests: XCTestCase {

    var fakeViewContext: FakeManagedObjectContext!
    var fakeAppDelegate: FakeAppDelegate!
    var subject: TransactionViewModel!
    
    override func setUp() {
        fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        fakePersistentContainer.fakeViewContext = fakeViewContext
        fakeAppDelegate = FakeAppDelegate(fakePersistentContainer)
        let baseInfoViewModel = TransactionBaseInfoViewModel.sharedInstance(appDelegate: fakeAppDelegate)
        subject = TransactionViewModel(baseInfoViewModel: baseInfoViewModel)
    }

    func testDateInfo() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let expectedDateInfo = "Date: \(dateFormatter.string(from: Date()))"
        
        // When
        let dateInfo = subject.dateInfo
        
        // Then
        XCTAssertEqual(dateInfo, expectedDateInfo)
    }

    func testTitleForSaveMoney() {
        // Given
        let expectedTitle = "Add Money to Savings"
        
        // When
        let title = subject.title(for: .save)
        
        // Then
        XCTAssertEqual(title, expectedTitle)
    }

    func testTitleForSpendMoney() {
        // Given
        let expectedTitle = "Add Money to Spending"
        
        // When
        let title = subject.title(for: .spend)
        
        // Then
        XCTAssertEqual(title, expectedTitle)
    }
    
    func testSaveTransaction() {
        // Given
        fakeAppDelegate.fakePersistentContainer = nil
        let baseInfoViewModel = TransactionBaseInfoViewModel.sharedInstance(appDelegate: fakeAppDelegate)
        subject = FakeTransactionViewModel(baseInfoViewModel: baseInfoViewModel)
        
        // When
        let saved = subject.processTransaction(userIndex: 0, moneyTransactionType: .spend, amount: "100.00", description: "", tagIndex: 0, transactionDataType: FakeTransaction.self, appDelegate: fakeAppDelegate)
        
        // Then
        XCTAssertTrue(saved)
        XCTAssertTrue(fakeAppDelegate.didSaveContext)
    }
    
    func testNotSaveTransactionIfUserIndexOutOfBoundry() {
        // Given, When
        let saved = subject.processTransaction(with: 3, moneyTransactionType: .spend, amount: "100.00", description: "", tagIndex: 0)
        
        // Then
        XCTAssertFalse(saved)
        XCTAssertFalse(fakeAppDelegate.didSaveContext)
    }
    
    func testNotSaveTransactionIfTagIndexOutOfBoundry() {
        // Given, When
        let saved = subject.processTransaction(with: 0, moneyTransactionType: .spend, amount: "100.00", description: "", tagIndex: 3)
        
        // Then
        XCTAssertFalse(saved)
        XCTAssertFalse(fakeAppDelegate.didSaveContext)
    }
    
    func testMatchDecimalPattern() {
        // Given, When
        let doesMatch = subject.doesMatchDecimalPattern("100.00")
        
        // Then
        XCTAssertTrue(doesMatch)
    }
    
    func testNotMatchDecimalPattern() {
        // Given, When
        let doesMatch = subject.doesMatchDecimalPattern("100.001")
        
        // Then
        XCTAssertFalse(doesMatch)
    }
    
    func testUserId() {
        // Given, When
        let testSubject = FakeTransactionViewModel()
        let userID = testSubject.userId(for: 0)
        
        // Then
        XCTAssertEqual(userID, "001")
    }
    
    func testUserIdWithWrongIndex() {
        // Given, When
        let testSubject = FakeTransactionViewModel()
        let userID = testSubject.userId(for: 10)
        
        // Then
        XCTAssertEqual(userID, "")
    }
    
    func testTagName() {
        // Given, When
        let testSubject = FakeTransactionViewModel()
        let tagName = testSubject.tagName(for: 0)
        
        // Then
        XCTAssertEqual(tagName, "tag1")
    }
    
    func testTagNameWrongIndex() {
        // Given, When
        let testSubject = FakeTransactionViewModel()
        let tagName = testSubject.tagName(for: 10)
        
        // Then
        XCTAssertEqual(tagName, "")
    }

}
