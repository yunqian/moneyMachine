//
//  TransactionViewControllerTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class TransactionViewControllerTests: XCTestCase {

    var subject: TransactionViewController!
    
    override func setUp() {
        super.setUp()
        subject =  UIStoryboard(name: "Main", bundle: Bundle(for: TransactionViewController.self)).instantiateViewController(withIdentifier: "TransactionViewController") as? TransactionViewController
        subject.loadViewIfNeeded()
    }

    func testTitleForSavings() {
        // Given, When
        subject.mondeyTransactionType = .save
        subject.viewDidLoad()
        
        // Then
        XCTAssertEqual(subject.title, "Add Money to Savings")
    }
    
    func testTitleForSpendings() {
        // Given, When
        subject.mondeyTransactionType = .spend
        subject.viewDidLoad()
        
        // Then
        XCTAssertEqual(subject.title, "Add Money to Spending")
    }
    
    func testDateLableText() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let expectedDateText = "Date: \(dateFormatter.string(from: Date()))"
        
        // When
        subject.viewDidLoad()
        
        // Then
        XCTAssertEqual(subject.dateLabel.text, expectedDateText)
    }
    
    func testDismissKeyboard() {
        // Given
        let fakeView = FakeView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        subject.view = fakeView
        
        // When
        subject.viewDidLoad()
        subject.dismissKeyboard(fakeView.gesture)
        
        // Then
        XCTAssertTrue(fakeView.gestureRecognizerAdded)
        XCTAssertTrue(fakeView.editingEnded)
    }
    
    func testShowTransactionSuccessMessage() {
        // Given
        subject.userIdPickerView = FakePickerView()
        subject.tagPickerView = FakePickerView()
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let fakeViewModel = TestTransactionViewModel()
        fakeViewModel.processSuccuss = true
        subject.setupProperties(viewModel: fakeViewModel, alertController: alertController)
        
        // When
        subject.submitButtonPressed(UIButton())
        
        // Then
        XCTAssertEqual(alertController.message!, "Transaction succuess!")
        XCTAssertEqual(alertController.actions.count, 1)
        
    }
    
    func testShowTransactionFailureMessage() {
        // Given
        subject.userIdPickerView = FakePickerView()
        subject.tagPickerView = FakePickerView()
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let fakeViewModel = TestTransactionViewModel()
        fakeViewModel.processSuccuss = false
        subject.setupProperties(viewModel: fakeViewModel, alertController: alertController)
        
        // When
        subject.submitButtonPressed(UIButton())
        
        // Then
        XCTAssertEqual(alertController.message!, "Transaction failure! Please try it again later.")
        XCTAssertEqual(alertController.actions.count, 1)
    }
    
    func testTextFieldDidBeginEditingWhenAmountIsZero() {
        // Given, When
        subject.amountTextField.text = "0"
        subject.textFieldDidBeginEditing(subject.amountTextField)
        
        // Then
        XCTAssertEqual(subject.amountTextField.text!, "")
    }
    
    func testTextFieldDidBeginEditingWhenAmountIsNotZero() {
        // Given, When
        subject.amountTextField.text = "100.00"
        subject.textFieldDidBeginEditing(subject.amountTextField)
        
        // Then
        XCTAssertEqual(subject.amountTextField.text!, "100.00")
    }
    
    func testTextFieldDidEndEditingWhenAmountIsBlank() {
        // Given, When
        subject.amountTextField.text = ""
        subject.textFieldDidEndEditing(subject.amountTextField)
        
        // Then
        XCTAssertEqual(subject.amountTextField.text!, "0.00")
    }
    
    func testTextFieldDidEndEditingWhenAmountIsNotBlank() {
        // Given, When
        subject.amountTextField.text = "100.00"
        subject.textFieldDidEndEditing(subject.amountTextField)
        
        // Then
        XCTAssertEqual(subject.amountTextField.text!, "100.00")
    }
    
    func testTextFieldDidEndEditingWhenAmountWithLeadingZeros() {
        // Given, When
        subject.amountTextField.text = "00100.00"
        subject.textFieldDidEndEditing(subject.amountTextField)
        
        // Then
        XCTAssertEqual(subject.amountTextField.text!, "100.00")
    }
    
    func testShouldChangeCharactersIfAmountIsValid() {
        // Given, When
        subject.amountTextField.text = "100"
        let range = NSMakeRange(0, 2)
        let shouldChange = subject.textField(subject.amountTextField, shouldChangeCharactersIn: range, replacementString: "1")
        
        // Then
        XCTAssertTrue(shouldChange)
    }
    
    func testShouldChangeCharactersIfAmountIsNotValid() {
        // Given, When
        subject.amountTextField.text = "100.00"
        let range = NSMakeRange(0, 5)
        let shouldChange = subject.textField(subject.amountTextField, shouldChangeCharactersIn: range, replacementString: "1")
        
        // Then
        XCTAssertFalse(shouldChange)
    }
    
    func testPickViewNumberOfComponents() {
        // Given, When
        let userPickViewNumberOfComponents = subject.numberOfComponents(in: subject.userIdPickerView)
        let tagPickViewNumberOfComponents = subject.numberOfComponents(in: subject.userIdPickerView)
        
        // Then
        XCTAssertEqual(userPickViewNumberOfComponents, 1)
        XCTAssertEqual(tagPickViewNumberOfComponents, 1)
    }
    
    func testPickViewNumberOfRowsInComponent() {
        // Given, When
        subject.setupProperties(viewModel: FakeTransactionViewModel())
        let userPickViewNumberOfRowsInComponent = subject.pickerView(subject.userIdPickerView, numberOfRowsInComponent: 0)
        let tagPickViewNumberOfRowsInComponent = subject.pickerView(subject.tagPickerView, numberOfRowsInComponent: 0)
        
        // Then
        XCTAssertEqual(userPickViewNumberOfRowsInComponent, 2)
        XCTAssertEqual(tagPickViewNumberOfRowsInComponent, 3)
    }
    
    func testPickViewTitleForRowt() {
        // Given, When
        subject.setupProperties(viewModel: FakeTransactionViewModel())
        let userRowTitle = subject.pickerView(subject.userIdPickerView, titleForRow: 0, forComponent: 0)
        let tagRowTitle = subject.pickerView(subject.tagPickerView, titleForRow: 0, forComponent: 0)
        
        // Then
        XCTAssertEqual(userRowTitle, "001")
        XCTAssertEqual(tagRowTitle, "tag1")
    }
    
}
