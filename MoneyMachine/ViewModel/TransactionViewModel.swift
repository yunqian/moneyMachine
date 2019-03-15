//
//  TransactionViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

class TransactionViewModel: TransactionBaseViewModel, TransactionViewModelProtocol {
    
    let savingName = "saving"
    let spendingName = "spending"
    let savingTitle = "Add Money to Savings"
    let spendingTitle = "Add Money to Spending"
    
    var dateInfo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return "Date: \(dateFormatter.string(from: Date()))"
    }
    
    func title(for transactionType: MoneyTransactionType) -> String {
        switch transactionType {
        case .save:
            return savingTitle
        default:
            return spendingTitle
        }
    }
    
    func processTransaction(with userIndex: Int,
                            moneyTransactionType: MoneyTransactionType,
                            amount: String,
                            description: String,
                            tagIndex: Int) -> Bool{
        return processTransaction(with: userIndex,
                                  moneyTransactionType: moneyTransactionType,
                                  amount: amount,
                                  description: description,
                                  tagIndex: tagIndex, transactionDataType: Transaction.self)
    }
    
    func processTransaction(with userIndex: Int,
                            moneyTransactionType: MoneyTransactionType,
                            amount: String,
                            description: String,
                            tagIndex: Int,
                            transactionDataType: TransactionProtocol.Type) -> Bool {
        
        guard userIndex <  users.count,
            tagIndex < tags.count,
            let context = context,
            let appDelegate = appDelegate else { return false }
        
        var transation = transactionDataType.init(context: context)
        transation.transactionType = getTransactionType(for: moneyTransactionType)
        transation.amount = transactionAmount(from: amount, transactionType: moneyTransactionType)
        transation.user = users[userIndex]
        transation.tag = tags[tagIndex]
        transation.note = description
        transation.date = Date()
        
        return appDelegate.saveContext(context)
        
    }
    
    func doesMatchDecimalPattern(_ text: String) -> Bool {
        let pattern = "^\\d+(\\.\\d{0,2})?$"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
            if results.count > 0 {
                return true
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
        }
        return false
    }
    
    func userId(for index: Int) -> String {
        guard index < users.count else { return ""}
        return users[index].id ?? ""
    }
    
    func tagName(for index: Int) -> String {
        guard index < tags.count else { return ""}
        return tags[index].name ?? ""
    }

}

private extension TransactionViewModel {
    
    func transactionTypeName(by transactionType: MoneyTransactionType) -> String {
        switch transactionType {
        case .save:
            return savingName
        default:
            return spendingName
        }
    }
    
    func transactionAmount(from amount: String, transactionType: MoneyTransactionType) -> Double {
        guard var transactionAmount = Double(amount) else { return 0.0 }
        
        if transactionType == .spend {
            transactionAmount = -transactionAmount
        }
        return transactionAmount
    }
    
    func getTransactionType(for moneyTransactionType: MoneyTransactionType) -> TransactionType? {
        let typeName = transactionTypeName(by: moneyTransactionType)
        return transactionTypes.first(where: { return $0.name == typeName })
    }
    
}
