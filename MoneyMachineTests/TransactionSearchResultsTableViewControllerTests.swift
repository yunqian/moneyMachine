//
//  TransactionSearchResultsTableViewControllerTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionSearchResultsTableViewControllerTests: XCTestCase {

    var subject: TransactionSearchResultsTableViewController!
    
    override func setUp() {
        super.setUp()
        subject = UIStoryboard(name: "Main", bundle: Bundle(for: TransactionSearchResultsTableViewController.self)).instantiateViewController(withIdentifier: "TransactionSearchResultsTableViewController") as? TransactionSearchResultsTableViewController
        subject.loadViewIfNeeded()
    }

    func testTitleTableHeaderViewAndFooterView() {
        // Given, When
        let expectedTitle = "Transactions"
        
        // Then
        XCTAssertEqual(subject.title, expectedTitle)
        XCTAssertEqual(subject.tableView.tableHeaderView, subject.headerView)
        XCTAssertNotNil(subject.tableView.tableFooterView)
        
    }

    // Test Table view data source, data delegate
    func testNumberOfSections() {
        // Given, When
        let numberOfSections = subject.numberOfSections(in: subject.tableView)
        
        // Then
        XCTAssertEqual(numberOfSections, 1)
    }
    
    func testNumberOfRowsInSection() {
        // Given
        let fakeTransaction = FakeTransaction(context: FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        let viewModel = TransactionSearchResultViewModel([fakeTransaction])
        subject.viewModel = viewModel
        
        // When
        let numberOfRowsInSection = subject.tableView(subject.tableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection, 1)
    }
    
    func testCellForRow() {
        // Given
        let fakeTransaction = FakeTransaction(context: FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        let viewModel = TransactionSearchResultViewModel([fakeTransaction])
        subject.viewModel = viewModel
        
        // When
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertTrue(cell is TransactionSearchResultTableViewCell)
    }

}
