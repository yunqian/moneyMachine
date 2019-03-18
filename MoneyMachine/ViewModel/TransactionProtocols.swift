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
    var userCount: Int { get }
    var tagCount: Int { get}
    var transactionTypes: [TransactionType] { get }
    var context: NSManagedObjectContext? { get }
}

protocol TransactionViewModelProtocol: TransactionBaseInfoProtocol {
    func userId(for index:Int) -> String
    func tagName(for index:Int) -> String
    var dateInfo: String { get }
    func title(for transactionType: MoneyTransactionType) -> String
    func processTransaction(with userIndex: Int,
                            moneyTransactionType: MoneyTransactionType,
                            amount: String,
                            description: String,
                            tagIndex: Int) -> Bool
    func doesMatchDecimalPattern(_ text: String) -> Bool
    
}

protocol TransactionSearchViewModelProtocol: TransactionBaseInfoProtocol {
    func userId(for index:Int) -> String
    func tagName(for index:Int) -> String
    func transactionTypeName(for index: Int) -> String
    var title: String { get }
    func searchTransaction(transactionTypeIndex: Int, userIdIndex: Int, tagNameIndex: Int, date: Date) -> [TransactionProtocol]
}

protocol TransactionProtocol {
    init(context moc: NSManagedObjectContext)
    var user: User? { get set }
    var tag: Tag? { get set }
    var transactionType: TransactionType? { get set }
    var amount: Double { get set }
    var note: String? { get set }
    var date: Date? { get set }
}

extension Transaction: TransactionProtocol { }

protocol TransactionReportProtocol {
    
    var numbersOfReportSection: Int { get }
    
    func rowNumbersOfReportSection(section: Int) -> Int
    
    func reportSectionTitle(section: Int) -> String
    
    func reportRowViewModel(at indexPath: IndexPath) -> TransactionResportRowViewModel
    
    func updatePeriodModel(at index: Int)
}
