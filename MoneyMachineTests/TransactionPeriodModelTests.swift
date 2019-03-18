//
//  TransactionPeriodModelTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/17/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionPeriodModelTests: XCTestCase {

    func testTransactionYearlyPeriodModel() {
        // Given, When
        let subject = TransactionYearlyPeriodModel()
        let datePattern = subject.dateFromFormatPattern(with: "2019")
        
        // Then
        XCTAssertEqual(subject.title, "Year: ")
        XCTAssertEqual(subject.periodFormatPattern, "yyyy")
        XCTAssertEqual(subject.calenderComponent, Calendar.Component.year)
        XCTAssertEqual(datePattern, "2019-01-01")
    }
    
    func testTransactionMonthlyPeriodModel() {
        // Given, When
        let subject = TransactionMonthlyPeriodModel()
        let datePattern = subject.dateFromFormatPattern(with: "2019-03")
        
        // Then
        XCTAssertEqual(subject.title, "Month: ")
        XCTAssertEqual(subject.periodFormatPattern, "yyyy-MM")
        XCTAssertEqual(subject.calenderComponent, Calendar.Component.month)
        XCTAssertEqual(datePattern, "2019-03-01")
    }
    
    func testTransactionWeeklyPeriodModel() {
        // Given, When
        let subject = TransactionWeeklyPeriodModel()
        let datePattern = subject.dateFromFormatPattern(with: "2019-03-15")
        
        // Then
        XCTAssertEqual(subject.title, "Week of ")
        XCTAssertEqual(subject.periodFormatPattern, "yyyy-MM-dd")
        XCTAssertEqual(subject.calenderComponent, Calendar.Component.weekOfYear)
        XCTAssertEqual(datePattern, "2019-03-15")
    }
    
    func testTransactionDailyPeriodModel() {
        // Given, When
        let subject = TransactionDailyPeriodModel()
        let datePattern = subject.dateFromFormatPattern(with: "2019-03-15")
        
        // Then
        XCTAssertEqual(subject.title, "Date: ")
        XCTAssertEqual(subject.periodFormatPattern, "yyyy-MM-dd")
        XCTAssertEqual(subject.calenderComponent, Calendar.Component.day)
        XCTAssertEqual(datePattern, "2019-03-15")
    }

}
