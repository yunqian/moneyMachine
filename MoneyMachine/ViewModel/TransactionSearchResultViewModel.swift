//
//  TransactionSearchResultViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

struct TransactionSearchResultViewModel {
    
    private let resultViewModel: [TransactionSearchResultCellViewModel]
    
    init(_ transactions: [TransactionProtocol]) {
        self.resultViewModel = transactions.map({ (transaction) -> TransactionSearchResultCellViewModel in
            return TransactionSearchResultCellViewModel(transaction: transaction)
        })
    }
    
    var numberOfRows: Int {
        return resultViewModel.count
    }
    
    func transactionResultCellViewModel(for index: Int) -> TransactionSearchResultCellViewModel {
        return resultViewModel[index]
    }
    
}

struct TransactionSearchResultCellViewModel {
    
    private let transaction: TransactionProtocol
    
    init(transaction: TransactionProtocol) {
        self.transaction = transaction
    }
    
    var userId: String {
        return transaction.user?.id ?? ""
    }
    
    var tagName: String {
        return transaction.tag?.name ?? ""
    }
    
    var amount: String {
        return "$\(String(format: "%.2f", transaction.amount))"
    }
    
    var description: String {
        return transaction.note ?? ""
    }
    
    var date: String {
        guard let transactionDate = transaction.date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return "\(dateFormatter.string(from: transactionDate))"
    }
    
}
