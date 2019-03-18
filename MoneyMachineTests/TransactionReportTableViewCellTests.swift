//
//  TransactionReportTableViewCellTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/17/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionReportTableViewCellTests: XCTestCase {

    func testTableViewCellDataBinding() {
        // Given
        let reportModel = TransactionReportModel(userId: "001", totalSpending: -100.0, totalSavings: 200.0, tags: ["Home","Other"])
        let reportViewModel = TransactionResportRowViewModel(reportModel: reportModel)
        
        let subject = TransactionReportTableViewCell.testSubject()
        
        // When
        subject.bindData(viewModel: reportViewModel)
        
        // Then
        XCTAssertEqual(subject.userLabel.text, "001")
        XCTAssertEqual(subject.totalSpendingLabel.text, "$-100.00")
        XCTAssertEqual(subject.totalSavingsLabel.text, "$200.00")
        XCTAssertEqual(subject.tagsLabel.text, "Home, Other")
    }

}
