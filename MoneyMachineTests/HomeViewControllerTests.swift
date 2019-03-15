//
//  HomeViewControllerTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class HomeViewControllerTests: XCTestCase {
    
    var subject: HomeViewController!
    
    override func setUp() {
        super.setUp()
        let navigationController = UIStoryboard(name: "Main", bundle: Bundle(for: HomeViewController.self)).instantiateInitialViewController() as? UINavigationController
        subject = navigationController?.viewControllers.first as? HomeViewController
        subject.loadViewIfNeeded()
    }
    
    func testTitle() {
        // Given, When
        subject.viewDidLoad()
        
        // Then
        XCTAssertEqual(subject.title, "Money Machine")
    }
    
    func testPrepareSegueToSaveMoney() {
        // Given
        let transactionViewController = UIStoryboard(name: "Main", bundle: Bundle(for: HomeViewController.self)).instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
        let fakeSegue = UIStoryboardSegue(identifier: "saveMoney", source: subject, destination: transactionViewController)
        
        // When
        subject.prepare(for: fakeSegue, sender: nil)
        
        // Then
        XCTAssertEqual(transactionViewController.mondeyTransactionType, .save)
    }
    
    func testPrepareSegueToSendMoney() {
        // Given
        let transactionViewController = UIStoryboard(name: "Main", bundle: Bundle(for: HomeViewController.self)).instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
        let fakeSegue = UIStoryboardSegue(identifier: "spendMoney", source: subject, destination: transactionViewController)
        
        // When
        subject.prepare(for: fakeSegue, sender: nil)
        
        // Then
        XCTAssertEqual(transactionViewController.mondeyTransactionType, .spend)
    }

}
