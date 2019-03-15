//
//  TransactionViewController.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

enum MoneyTransactionType {
    case spend
    case save
}

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var userIdPickerView: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var tagPickerView: UIPickerView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var mondeyTransactionType: MoneyTransactionType = .spend
    private var viewModel: TransactionViewModelProtocol
    private var alertController: UIAlertController
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = TransactionViewModel()
        self.alertController = UIAlertController(title: nil,
                                                 message: "",
                                                 preferredStyle: .alert)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        
        title = viewModel.title(for: mondeyTransactionType)
        dateLabel.text = viewModel.dateInfo
        addTapGesture()
    }
    
    func setupProperties(viewModel: TransactionViewModelProtocol = TransactionViewModel(),
                         alertController: UIAlertController = UIAlertController(title: nil,
                                                                                message: "",
                                                                                preferredStyle: .alert)) {
        self.viewModel = viewModel
        self.alertController = alertController
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let userRow = userIdPickerView.selectedRow(inComponent: 0)
        let tagRow = tagPickerView.selectedRow(inComponent: 0)
        var message = "Transaction failure! Please try it again later."
        
        if viewModel.processTransaction(with: userRow,
                                        moneyTransactionType: mondeyTransactionType,
                                        amount: amountTextField.text ?? "",
                                        description: descriptionTextField.text ?? "",
                                        tagIndex: tagRow) {
            message = "Transaction succuess!"
        }
        showAlert(with: message)
    }
    
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer?){
        view.endEditing(true)
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    private func showAlert(with message: String) {
        alertController.message = message
        if alertController.actions.count == 0 {
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}

extension TransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension TransactionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == amountTextField,
            let transactionAmount = Double(amountTextField.text ?? ""),
            transactionAmount > 0 else {
                amountTextField.text = ""
                return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == amountTextField,
            let transactionAmount = Double(amountTextField.text ?? ""),
            transactionAmount > 0 else {
                amountTextField.text = "0.00"
                return
        }
        amountTextField.text = "\(String(format: "%.2f", transactionAmount))"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == amountTextField else { return true }
        if (isBackspace(string)) {
            return true
        }
        
        let text = "\(amountTextField.text ?? "")\(string)"
        return viewModel.doesMatchDecimalPattern(text)
    }
    
    private func isBackspace(_ string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        return false
    }
   
}
