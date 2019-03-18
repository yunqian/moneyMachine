//
//  TransactionReportViewModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/18/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionReportViewModelTests: XCTestCase {

    var fakeViewContext: FakeManagedObjectContext!
    var fakeAppDelegate: FakeAppDelegate!
    var subject: TransactionReportViewModel!
    
    override func setUp() {
        fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        fakePersistentContainer.fakeViewContext = fakeViewContext
        fakeAppDelegate = FakeAppDelegate(fakePersistentContainer)
        subject = TransactionReportViewModel(appDelegate: fakeAppDelegate)
    }

    func testUpdatePeriodModel() {
        // Given, When
        subject.updatePeriodModel(at: 0)
        let periodModel0 = subject.periodModel
        subject.updatePeriodModel(at: 1)
        let periodModel1 = subject.periodModel
        subject.updatePeriodModel(at: 2)
        let periodModel2 = subject.periodModel
        subject.updatePeriodModel(at: 3)
        let periodModel3 = subject.periodModel
        
        // Then
        XCTAssertTrue(periodModel0 is TransactionYearlyPeriodModel)
        XCTAssertTrue(periodModel1 is TransactionMonthlyPeriodModel)
        XCTAssertTrue(periodModel2 is TransactionWeeklyPeriodModel)
        XCTAssertTrue(periodModel3 is TransactionDailyPeriodModel)
    }

    func testUpdateTransactionReport() {
        // Given, When
        let dates = [["date": Date()]]
        fakeViewContext.fetchResult = dates
        let oldTransactionReport = subject.transactionReport
        subject.updatePeriodModel(at: 0)
        let newTransactionReport = subject.transactionReport
        
        // Then
        XCTAssertEqual(oldTransactionReport.count, 0)
        XCTAssertEqual(newTransactionReport.count, 1)
    }
    
    func testNumbersOfReportSection() {
        // Given, When
        let dates = [["date": Date()]]
        fakeViewContext.fetchResult = dates
        subject.updatePeriodModel(at: 0)
        let numbersOfReportSection = subject.numbersOfReportSection
        
        // Then
        XCTAssertEqual(numbersOfReportSection, 1)
    }
    
    func testRowNumbersOfReportSection() {
        // Given
        let dates = [["date": Date()]]
        fakeViewContext.fetchResult = dates
        let transactionFetchResult = [["user.id":"001","sumOfAmount":"200","transactionType.name": "savings"]]
        fakeViewContext.transactionFetchResult = transactionFetchResult
        
        // When
        subject.updatePeriodModel(at: 0)
        let rowNumbersOfReportSection = subject.rowNumbersOfReportSection(section: 0)
        
        // Then
        XCTAssertEqual(rowNumbersOfReportSection, 1)
    }
    
    func testRowNumbersOfReportSectionWhenSectionOutOfRange() {
        // Given
        let dates = [["date": Date()]]
        fakeViewContext.fetchResult = dates
        let transactionFetchResult = [["user.id":"001","sumOfAmount":"200","transactionType.name": "savings"]]
        fakeViewContext.transactionFetchResult = transactionFetchResult
        
        // When
        subject.updatePeriodModel(at: 0)
        let rowNumbersOfReportSection = subject.rowNumbersOfReportSection(section: 10)
        
        // Then
        XCTAssertEqual(rowNumbersOfReportSection, 0)
    }
    
    func testReportSectionTitle() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2019-03-15")!
        let dates = [["date": date]]
        fakeViewContext.fetchResult = dates
        
        // When
        let defaultReportSectionTitle = subject.reportSectionTitle(section: 10)
        subject.updatePeriodModel(at: 0)
        let reportSectionTitle0 = subject.reportSectionTitle(section: 0)
        subject.updatePeriodModel(at: 1)
        let reportSectionTitle1 = subject.reportSectionTitle(section: 0)
        subject.updatePeriodModel(at: 2)
        let reportSectionTitle2 = subject.reportSectionTitle(section: 0)
        subject.updatePeriodModel(at: 3)
        let reportSectionTitle3 = subject.reportSectionTitle(section: 0)
        
        // Then
        XCTAssertEqual(defaultReportSectionTitle, "")
        XCTAssertEqual(reportSectionTitle0, "Year: 2019")
        XCTAssertEqual(reportSectionTitle1, "Month: 2019-03")
        XCTAssertEqual(reportSectionTitle2, "Week of 2019-03-11")
        XCTAssertEqual(reportSectionTitle3, "Date: 2019-03-15")
    }
    
    func testReportRowViewModel() {
        // Given
        let dates = [["date": Date()]]
        fakeViewContext.fetchResult = dates
        let transactionFetchResult = [["user.id":"001", "sumOfAmount": 200, "transactionType.name": "savings"], ["user.id": "001","sumOfAmount": 100, "transactionType.name": "spending"]]
        fakeViewContext.transactionFetchResult = transactionFetchResult
        let tagFetchResult = [["tag.name":"Tech"],["tag.name":"Account"]]
        fakeViewContext.tagFetchResult = tagFetchResult
        
        // When
        subject.updatePeriodModel(at: 0)
        let resportRowViewModel = subject.reportRowViewModel(at: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertEqual(resportRowViewModel.userId, "001")
        XCTAssertEqual(resportRowViewModel.totalSavings, "$200.00")
        XCTAssertEqual(resportRowViewModel.totalSpending, "$100.00")
        XCTAssertEqual(resportRowViewModel.tags, "Account, Tech")
    }

    func testReportRowViewModelWhenIndexPathOutOfRange() {
        // Given
        let dates = [["date": Date()]]
        fakeViewContext.fetchResult = dates
        let transactionFetchResult = [["user.id":"001", "sumOfAmount": 200, "transactionType.name": "savings"], ["user.id": "001","sumOfAmount": 100, "transactionType.name": "spending"]]
        fakeViewContext.transactionFetchResult = transactionFetchResult
        let tagFetchResult = [["tag.name":"Tech"],["tag.name":"Account"]]
        fakeViewContext.tagFetchResult = tagFetchResult
        
        // When
        subject.updatePeriodModel(at: 0)
        let resportRowViewModel = subject.reportRowViewModel(at: IndexPath(row: 10, section: 10))
        
        // Then
        XCTAssertNotNil(resportRowViewModel)
        XCTAssertEqual(resportRowViewModel.userId, "")
        XCTAssertEqual(resportRowViewModel.totalSavings, "$0.00")
        XCTAssertEqual(resportRowViewModel.totalSpending, "$0.00")
        XCTAssertEqual(resportRowViewModel.tags, "")
    }
}
