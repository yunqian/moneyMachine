//
//  TransactionSearchViewControllerTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionSearchViewControllerTests: XCTestCase {

    var subject: TransactionSearchViewController!
    var searchViewModel: TransactionSearchViewModel!
    
    override func setUp() {
        super.setUp()
        subject = UIStoryboard(name: "Main", bundle: Bundle(for: TransactionSearchViewController.self)).instantiateViewController(withIdentifier: "TransactionSearchViewController") as? TransactionSearchViewController
        subject.loadViewIfNeeded()
        
        let fakeViewModel = FakeTransactionViewModel()
        searchViewModel = TransactionSearchViewModel(baseInfoViewModel: fakeViewModel)
        subject.setupViewModel(viewModel: searchViewModel)
    }

    func testTitle() {
        // Given, When
        let expectedTitle = searchViewModel.title
        
        // Then
        XCTAssertEqual(subject.title, expectedTitle)
    }
    
    func testTransactionSegmentedControlTitles() {
        // Given, When
        subject.setupViewModel(viewModel: searchViewModel)
        subject.viewDidLoad()
        let expectedTitle0 = searchViewModel.transactionTypeName(for: 0)
        let expectedTitle1 = searchViewModel.transactionTypeName(for: 1)
        
        // Then
        XCTAssertEqual(subject.transactionSegmentedControl.titleForSegment(at: 0), expectedTitle0)
        XCTAssertEqual(subject.transactionSegmentedControl.titleForSegment(at: 1), expectedTitle1)
    }
    
    func testPrepareSegueToShowTransactionResults() {
        // Given
        let fakeSearchViewModel = FakeTransactionSearchViewModel(baseInfoViewModel: FakeTransactionViewModel())
        subject.setupViewModel(viewModel: fakeSearchViewModel)
        
        let transactionViewController = UIStoryboard(name: "Main", bundle: Bundle(for: TransactionSearchResultsTableViewController.self)).instantiateViewController(withIdentifier: "TransactionSearchResultsTableViewController") as! TransactionSearchResultsTableViewController
        let fakeSegue = UIStoryboardSegue(identifier: "showResult", source: subject, destination: transactionViewController)
        
        // When
        subject.prepare(for: fakeSegue, sender: nil)
        
        // Then
        XCTAssertNotNil(transactionViewController.viewModel)
        XCTAssertEqual(transactionViewController.viewModel.numberOfRows, fakeSearchViewModel.fakeTransactions.count)
    }
}
