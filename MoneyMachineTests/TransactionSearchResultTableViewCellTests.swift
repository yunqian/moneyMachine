//
//  TransactionSearchResultTableViewCellTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionSearchResultTableViewCellTests: XCTestCase {

    func testTableViewCellDataBinding() {
        // Given
        let fakeTransaction = FakeTransaction(context: FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
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
        
        let viewModel = TransactionSearchResultCellViewModel(transaction: fakeTransaction)
        let subject = TransactionSearchResultTableViewCell.testSubject()
        
        // When
        subject.bindData(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(subject.userLabel.text, "001")
        XCTAssertEqual(subject.amountLabel.text, "$100.00")
        XCTAssertEqual(subject.tagLabel.text, "Other")
        XCTAssertEqual(subject.descriptionLabel.text, "test note")
        XCTAssertEqual(subject.dateLabel.text, expectedDateString)
    }

}
