//
//  TransactionProtocols.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import Foundation
import CoreData

protocol TransactionBaseInfoProtocol {
    var users: [User] { get }
    var tags: [Tag] { get }
    var transactionTypes: [TransactionType] { get }
    var context: NSManagedObjectContext? { get }
}

protocol TransactionViewModelProtocol: TransactionBaseInfoProtocol {
    var dateInfo: String { get }
    func title(for transactionType: MoneyTransactionType) -> String
    func userId(for index:Int) -> String
    func tagName(for index:Int) -> String
    func processTransaction(with userIndex:Int,
                            moneyTransactionType: MoneyTransactionType,
                            amount: String,
                            description: String,
                            tagIndex: Int) -> Bool
    func doesMatchDecimalPattern(_ text: String) -> Bool
    
}
