//
//  TransactionReportViewControllerTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionReportViewControllerTests: XCTestCase {
    
    var subject: TransactionReportViewController!
    var fakeReportViewModel: FakeTransactionReportViewModel!
    
    override func setUp() {
        super.setUp()
        subject = UIStoryboard(name: "Main", bundle: Bundle(for: TransactionReportViewController.self)).instantiateViewController(withIdentifier: "TransactionReportViewController") as? TransactionReportViewController
        subject.loadViewIfNeeded()
        fakeReportViewModel = FakeTransactionReportViewModel()
        subject.viewModel = fakeReportViewModel
    }
    
    func testTitleTableHeaderViewAndFooterView() {
        // Given, When
        let expectedTitle = "Report"
        
        // Then
        XCTAssertEqual(subject.title, expectedTitle)
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
        // Given, When
        let numberOfRowsInSection = subject.tableView(subject.tableView, numberOfRowsInSection: 0)
        let expectedNumberOfRowsInSection = subject.viewModel.rowNumbersOfReportSection(section: 0) + 1
        
        // Then
        XCTAssertEqual(numberOfRowsInSection, expectedNumberOfRowsInSection)
    }
    
    func testCellForFirstRow() {
        // Given,  When
        subject.loadView()
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertFalse(cell is TransactionReportTableViewCell)
    }
    
    func testCellForSecondRow() {
        // Given,  When
        subject.loadView()
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        
        // Then
        XCTAssertTrue(cell is TransactionReportTableViewCell)
    }
    
    func testUpdateUpdateReportDateDuringViewDidLoad() {
        // Given,  When
        subject.viewDidLoad()
        
        // Then
        XCTAssertTrue(fakeReportViewModel.didUpdatePeriodModel)
        XCTAssertEqual(fakeReportViewModel.updateIndex, 0)
    }
    
    func testSegmentedControlValueChanged() {
        // Given,  When
        subject.loadView()
        subject.reportSegmentedControl.selectedSegmentIndex = 2
        subject.segmentedControlValueChanged(subject.reportSegmentedControl)
        
        // Then
        XCTAssertTrue(fakeReportViewModel.didUpdatePeriodModel)
        XCTAssertEqual(fakeReportViewModel.updateIndex, 2)
    }
}
