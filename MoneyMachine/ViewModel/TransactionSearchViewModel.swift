//
//  TransactionSearchViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

class TransactionSearchViewModel: TransactionBaseViewModel, TransactionSearchViewModelProtocol {
    
    var title: String = "Search Transcation"
    
    override var userCount: Int {
        return userIds.count
    }
    
    override var tagCount: Int {
        return tagNames.count
    }
    
    private lazy var userIds: [String] = {
        guard var allUserIds = users.map({ $0.id }) as? [String] else { return [] }
        allUserIds.insert("All Users", at: 0)
        return allUserIds
    }()
    
    private lazy var tagNames: [String] = {
        guard var allTagNames = tags.map({ $0.name }) as? [String] else { return [] }
        allTagNames.insert("All Tags", at: 0)
        return allTagNames
    }()
    
    func transactionTypeName(for index: Int) -> String {
        guard index < transactionTypes.count else { return ""}
        return transactionTypes[index].name?.capitalized ?? ""
    }
    
    func userId(for index: Int) -> String {
        guard index < userIds.count else { return ""}
        return userIds[index]
    }
    
    func tagName(for index: Int) -> String {
        guard index < tagNames.count else { return ""}
        return tagNames[index]
    }
    
    func searchTransaction(transactionTypeIndex: Int, userIdIndex: Int, tagNameIndex: Int, date: Date) -> [TransactionProtocol] {
        var predicts: [NSPredicate] = []
        
        if let transactionTypePredict = transactionTypePredict(for: transactionTypeIndex)  {
            predicts.append(transactionTypePredict)
        }
        if let tagPredict = tagPredict(for: tagNameIndex)  {
            predicts.append(tagPredict)
        }
        if let userPredict = userPredict(for: userIdIndex)  {
            predicts.append(userPredict)
        }
        
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        if let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) {
            let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
            predicts.append(fromPredicate)
            predicts.append(toPredicate)
        }
        
        guard let transactions = searchData(predicts) as? [TransactionProtocol] else { return [] }
        return transactions
    }
    
}

private extension TransactionSearchViewModel {
    
    func userPredict(for selectedIndex: Int) -> NSPredicate? {
        guard selectedIndex > 0, selectedIndex < userIds.count  else { return nil }
        return NSPredicate(format: "user.id == '\(userIds[selectedIndex])'")
    }
    
    func tagPredict(for selectedIndex: Int) -> NSPredicate? {
        guard selectedIndex > 0, selectedIndex < tagNames.count  else { return nil }
        return NSPredicate(format: "tag.name == '\(tagNames[selectedIndex])'")
    }
    
    func transactionTypePredict(for selectedIndex: Int) -> NSPredicate? {
        let typeName = transactionTypeName(for: selectedIndex)
        guard tagNames.count > 0 else { return nil }
        return NSPredicate(format: "transactionType.name == '\(typeName.lowercased())'")
    }
    
    func searchData(_ predicates: [NSPredicate]) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        
        fetchRequest.predicate = predicate
        do {
            if let results = try context?.fetch(fetchRequest) {
                return results
            }
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return []
    }
    
}
