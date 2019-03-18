//
//  TransactionBaseInfoViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionBaseInfoViewModelTests: XCTestCase {

    var fakeViewContext: FakeManagedObjectContext!
    var subject: TransactionBaseInfoViewModel!
    
    override func setUp() {
        fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        fakePersistentContainer.fakeViewContext = fakeViewContext
        let fakeAppDelegate = FakeAppDelegate(fakePersistentContainer)
        subject = TransactionBaseInfoViewModel(appDelegate: fakeAppDelegate)
    }
    
    func testUserCount() {
        // Given
        let users = [User(), User()]
        fakeViewContext.fetchResult = users
        
        // When
        let userCount = subject.userCount
        
        // Then
        XCTAssertEqual(userCount, 2)
    }
    
    func testTagCount() {
        // Given
        let tags = [Tag(), Tag(), Tag()]
        fakeViewContext.fetchResult = tags
        
        // When
        let tagCount = subject.tagCount
        
        // Then
        XCTAssertEqual(tagCount, 3)
    }

    func testGetUsers() {
        // Given
        let expectedUsers = [User(), User()]
        fakeViewContext.fetchResult = expectedUsers
        
        // When
        let users = subject.users
        
        // Then
        XCTAssertNotNil(users)
        XCTAssertEqual(users.count, 2)
    }
    
    func testGetUsersWithWrongType() {
        // Given
        let expectedUsers = [NSObject(), NSObject()]
        fakeViewContext.fetchResult = expectedUsers
        
        // When
        let users = subject.users
        
        // Then
        XCTAssertNotNil(users)
        XCTAssertEqual(users.count, 0)
    }
    
    func testGetUsersWithError() {
        // Given
        let expectedUsers = [User(), User()]
        fakeViewContext.fetchResult = expectedUsers
        fakeViewContext.error = NSError(domain: "error", code: 0, userInfo: [:])

        // When
        let users = subject.users
        
        // Then
        XCTAssertNotNil(users)
        XCTAssertEqual(users.count, 0)
    }
    
    func testGetTags() {
        // Given
        let expectedTags = [Tag(), Tag()]
        fakeViewContext.fetchResult = expectedTags
        
        // When
        let tags = subject.tags
        
        // Then
        XCTAssertNotNil(tags)
        XCTAssertEqual(tags.count, 2)
    }
    
    func testGetTagsWithWrongType() {
        // Given
        let expectedTags = [NSObject(), NSObject()]
        fakeViewContext.fetchResult = expectedTags
        
        // When
        let tags = subject.tags
        
        // Then
        XCTAssertNotNil(tags)
        XCTAssertEqual(tags.count, 0)
    }
    
    func testGetTagsWithError() {
        // Given
        let expectedTags = [Tag(), Tag()]
        fakeViewContext.fetchResult = expectedTags
        fakeViewContext.error = NSError(domain: "error", code: 0, userInfo: [:])

        // When
        let tags = subject.tags
        
        // Then
        XCTAssertNotNil(tags)
        XCTAssertEqual(tags.count, 0)
    }

    func testGetTransactionTypes() {
        // Given
        let expectedTypes = [TransactionType(), TransactionType()]
        fakeViewContext.fetchResult = expectedTypes
        
        // When
        let types = subject.transactionTypes
        
        // Then
        XCTAssertNotNil(types)
        XCTAssertEqual(types.count, 2)
    }
    
    func testGetTransactionTypesWithWrongType() {
        // Given
        let expectedTypes = [NSObject(), NSObject()]
        fakeViewContext.fetchResult = expectedTypes
        
        // When
        let types = subject.transactionTypes
        
        // Then
        XCTAssertNotNil(types)
        XCTAssertEqual(types.count, 0)
    }
    
    func testGetTransactionTypesWithError() {
        // Given
        let expectedTypes = [TransactionType(), TransactionType()]
        fakeViewContext.fetchResult = expectedTypes
        fakeViewContext.error = NSError(domain: "error", code: 0, userInfo: [:])

        // When
        let types = subject.transactionTypes
        
        // Then
        XCTAssertNotNil(types)
        XCTAssertEqual(types.count, 0)
    }
    
}
