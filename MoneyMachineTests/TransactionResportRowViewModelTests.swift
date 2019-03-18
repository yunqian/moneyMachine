//
//  TransactionResportRowViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/17/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionResportRowViewModelTests: XCTestCase {

    func testCorrectProperties() {
        // Given, When
        let reportModel = TransactionReportModel(userId: "001", totalSpending: -100.0, totalSavings: 200.0, tags: ["Home","Other"])
        let subject = TransactionResportRowViewModel(reportModel: reportModel)
        
        // Then
        XCTAssertEqual(subject.userId, "001")
        XCTAssertEqual(subject.totalSpending, "$-100.00")
        XCTAssertEqual(subject.totalSavings, "$200.00")
        XCTAssertEqual(subject.tags, "Home, Other")
    }

}
