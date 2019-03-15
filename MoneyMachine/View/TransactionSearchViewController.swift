//
//  TransactionSearchViewController.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

class TransactionSearchViewController: UIViewController {

    @IBOutlet var transactionSegmentedControl: UISegmentedControl!
    @IBOutlet var userIdPickerView: UIPickerView!
    @IBOutlet var tagPickerView: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    
    private var viewModel: TransactionSearchViewModelProtocol
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = TransactionSearchViewModel()
        super.init(coder: aDecoder)
    }
    
    func setupViewModel(viewModel: TransactionSearchViewModelProtocol = TransactionSearchViewModel()) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTransactionSegmentedControl()
        title = viewModel.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transactionTypeIndex = transactionSegmentedControl.selectedSegmentIndex
        let userRow = userIdPickerView.selectedRow(inComponent: 0)
        let tagRow = tagPickerView.selectedRow(inComponent: 0)
        let date = datePicker.date
        let transactions = viewModel.searchTransaction(transactionTypeIndex: transactionTypeIndex, userIdIndex: userRow, tagNameIndex: tagRow, date: date)
        if let transactionViewController = segue.destination as? TransactionSearchResultsTableViewController {
            transactionViewController.viewModel = TransactionSearchResultViewModel(transactions)
        }
        
        super .prepare(for: segue, sender: sender)
    }
    
}

private extension TransactionSearchViewController {
    
    func setupTransactionSegmentedControl() {
        transactionSegmentedControl.setTitle(viewModel.transactionTypeName(for: 0), forSegmentAt: 0)
        transactionSegmentedControl.setTitle(viewModel.transactionTypeName(for: 1), forSegmentAt: 1)
    }
}

extension TransactionSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == userIdPickerView {
            return viewModel.userCount
        } else {
            return viewModel.tagCount
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == userIdPickerView {
            return viewModel.userId(for: row)
        } else {
            return viewModel.tagName(for: row)
        }
    }
    
}
