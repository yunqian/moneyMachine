//
//  TransactionSearchViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionSearchViewModelTests: XCTestCase {

  //  var fakeViewContext: FakeManagedObjectContext!
    let fakeViewModel = FakeTransactionViewModel()
    var subject: TransactionSearchViewModel!
    
    override func setUp() {
        subject = TransactionSearchViewModel(baseInfoViewModel: fakeViewModel)
    }
    
    func testTitle() {
        // Given, When
        let expectedTitle = "Search Transcation"
        
        // Then
        XCTAssertEqual(subject.title, expectedTitle)
    }

    func testUserCountAndTagCount() {
        // Given, When
        let expectedUserCount = fakeViewModel.users.count + 1
        let expectedTagCount = fakeViewModel.tags.count + 1
        
        // Then
        XCTAssertEqual(subject.userCount, expectedUserCount)
        XCTAssertEqual(subject.tagCount, expectedTagCount)
    }
    
    func testTransactionTypeName() {
        // Given, When
        let expectedTransactionTypeName = fakeViewModel.transactionTypes[0].name?.capitalized
        let transactionTypeName = subject.transactionTypeName(for: 0)
        let invalidTransactionTypeName = subject.transactionTypeName(for: 10)
            
        // Then
        XCTAssertEqual(transactionTypeName, expectedTransactionTypeName)
        XCTAssertEqual(invalidTransactionTypeName, "")
    }
    
    func testUserId() {
        // Given, When
        let expectedAllUserId = "All Users"
        let expectedUserId = fakeViewModel.users[0].id
        let firstUserId = subject.userId(for: 0)
        let secondUserId = subject.userId(for: 1)
        let invalidUserId = subject.userId(for: 10)
        
        // Then
        XCTAssertEqual(firstUserId, expectedAllUserId)
        XCTAssertEqual(secondUserId, expectedUserId)
        XCTAssertEqual(invalidUserId, "")
    }
    
    func testTagName() {
        // Given, When
        let expectedAllTagName = "All Tags"
        let expectedTagNAme = fakeViewModel.tags[0].name
        let firstTagName = subject.tagName(for: 0)
        let secondTagName = subject.tagName(for: 1)
        let invalidTagName = subject.tagName(for: 10)
        
        // Then
        XCTAssertEqual(firstTagName, expectedAllTagName)
        XCTAssertEqual(secondTagName, expectedTagNAme)
        XCTAssertEqual(invalidTagName, "")
    }
    
    func testSearchTransactionWithResults() {
        // Given
        let fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fakeTransaction = FakeTransaction(context: FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        fakeViewContext.fetchResult = [fakeTransaction]
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        fakePersistentContainer.fakeViewContext = fakeViewContext
        let fakeAppDelegate = FakeAppDelegate(fakePersistentContainer)
        let baseInfoViewModel = TransactionBaseInfoViewModel.sharedInstance(appDelegate: fakeAppDelegate)
        subject = TransactionSearchViewModel(baseInfoViewModel: baseInfoViewModel)
        
        // When
        let transactionResults = subject.searchTransaction(transactionTypeIndex: 0, userIdIndex: 0, tagNameIndex: 0, date: Date())
        
        // Then
        XCTAssertNotNil(fakeViewContext.fetchRequest?.predicate)
        XCTAssertNotNil(transactionResults)
        XCTAssertEqual(transactionResults.count, 1)
    }
    
    func testSearchTransactionWithWrongResultType() {
        // Given
        let fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        fakeViewContext.fetchResult = [NSObject()]
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        fakePersistentContainer.fakeViewContext = fakeViewContext
        let fakeAppDelegate = FakeAppDelegate(fakePersistentContainer)
        let baseInfoViewModel = TransactionBaseInfoViewModel.sharedInstance(appDelegate: fakeAppDelegate)
        subject = TransactionSearchViewModel(baseInfoViewModel: baseInfoViewModel)
        
        // When
        let transactionResults = subject.searchTransaction(transactionTypeIndex: 0, userIdIndex: 0, tagNameIndex: 0, date: Date())
        
        // Then
        XCTAssertNotNil(transactionResults)
        XCTAssertEqual(transactionResults.count, 0)
    }
    
    func testSearchTransactionWithError() {
        // Given
        let fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        fakeViewContext.error = NSError(domain: "error", code: 0, userInfo: [:])
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        fakePersistentContainer.fakeViewContext = fakeViewContext
        let fakeAppDelegate = FakeAppDelegate(fakePersistentContainer)
        let baseInfoViewModel = TransactionBaseInfoViewModel.sharedInstance(appDelegate: fakeAppDelegate)
        subject = TransactionSearchViewModel(baseInfoViewModel: baseInfoViewModel)
        
        // When
        let transactionResults = subject.searchTransaction(transactionTypeIndex: 0, userIdIndex: 0, tagNameIndex: 0, date: Date())
        
        // Then
        XCTAssertNotNil(transactionResults)
        XCTAssertEqual(transactionResults.count, 0)
    }

}
