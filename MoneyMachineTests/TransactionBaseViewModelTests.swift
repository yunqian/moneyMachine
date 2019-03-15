//
//  TransactionBaseViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionBaseViewModelTests: XCTestCase {

    var fakeBaseInfoViewModel: FakeTransactionBaseInfoViewModel!
    var subject: TransactionBaseViewModel!
    
    override func setUp() {
        fakeBaseInfoViewModel = FakeTransactionBaseInfoViewModel()
        subject = TransactionBaseViewModel(baseInfoViewModel: fakeBaseInfoViewModel)
    }

    func testBaseInfoViewModelSingleton() {
        // Given, When
        let transactionBaseViewModel1 = TransactionBaseViewModel()
        let transactionBaseViewModel2 = TransactionBaseViewModel()
        
        // Then
        XCTAssertNotEqual(transactionBaseViewModel1, transactionBaseViewModel2)
        XCTAssertEqual(transactionBaseViewModel1.baseInfoViewModel as! TransactionBaseInfoViewModel,
                       transactionBaseViewModel2.baseInfoViewModel as! TransactionBaseInfoViewModel)
        
    }
    
    func testProperties() {
        // Given, When
        let expectedUserCount = fakeBaseInfoViewModel.userCount
        let expectedTagCount = fakeBaseInfoViewModel.tagCount
        let expectedUsers = fakeBaseInfoViewModel.users
        let expectedTransactionTypes = fakeBaseInfoViewModel.transactionTypes
        let expectedContext = fakeBaseInfoViewModel.context
        
        // Then
        XCTAssertEqual(subject.userCount, expectedUserCount)
        XCTAssertEqual(subject.tagCount, expectedTagCount)
        XCTAssertEqual(subject.users.count, expectedUsers.count)
        XCTAssertEqual(subject.transactionTypes.count, expectedTransactionTypes.count)
        XCTAssertEqual(subject.context, expectedContext)
    }
}
