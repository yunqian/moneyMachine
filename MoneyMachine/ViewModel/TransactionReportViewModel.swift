//
//  TransactionReportViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

class TransactionReportViewModel {

    private var allTransactionDates: [Date]?
    private (set) var periodModel: TransactionPeriodModelProtocol?
    private (set) var transactionReport: Dictionary<String, [TransactionReportModel]> = Dictionary()
    private (set) var context: NSManagedObjectContext?
    
    init(appDelegate: UIApplicationDelegate? = UIApplication.shared.delegate) {
        if let appDelegate = appDelegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
    }
}

extension TransactionReportViewModel: TransactionReportProtocol {
    
    @objc func updatePeriodModel(at index: Int) {
        guard let period = TransactionPeriodType(rawValue: index) else { return }
        switch period {
        case .yearly:
            periodModel = TransactionYearlyPeriodModel()
        case .monthly:
            periodModel = TransactionMonthlyPeriodModel()
        case .weekly:
            periodModel = TransactionWeeklyPeriodModel()
        case .daily:
            periodModel = TransactionDailyPeriodModel()
        }
        transactionReport = Dictionary()
        buildReport()
    }
    
    var numbersOfReportSection: Int {
        return transactionReport.keys.count
    }
    
    func rowNumbersOfReportSection(section: Int) -> Int {
        guard section < transactionReport.keys.count else { return 0 }
        let key = sortedSectionKeys[section]
        return transactionReport[key]?.count ?? 0
    }
    
    func reportSectionTitle(section: Int) -> String {
        guard section < transactionReport.keys.count else { return "" }
        let defaultTitle = periodModel?.title ?? ""
        return "\(defaultTitle)\(sortedSectionKeys[section])"
    }
    
    func reportRowViewModel(at indexPath: IndexPath) -> TransactionResportRowViewModel {
        guard indexPath.section < transactionReport.keys.count else {
            return TransactionResportRowViewModel()
        }
        let key = sortedSectionKeys[indexPath.section]
        guard let reportModels = transactionReport[key],
            indexPath.row < reportModels.count else {
                return TransactionResportRowViewModel()
        }
        return TransactionResportRowViewModel(reportModel: reportModels[indexPath.row])
    }
}

private extension TransactionReportViewModel {
    
    var sortedSectionKeys: [String] {
        return Array(transactionReport.keys).sorted(by: >)
    }

    func buildReport() {
        guard let model = periodModel else { return }
        
        let distinctPeriod = distinctTransactionPeriod(periodFormatPattern: model.periodFormatPattern)
        distinctPeriod.forEach { (period) in
            if let model = periodModel,
                let predicate = periodPredict(for: model.calenderComponent, periodFrom: model.dateFromFormatPattern(with: period)),
                let data = reportSumByUserAndTransaction(with: predicate) as? [NSDictionary] {
                let reportModels = allReportModels(from: data, predict: predicate)
                transactionReport[period] = reportModels.sorted(by: { $0.userId < $1.userId })
            }
        }
    }
    
    func searchData(_ predicates: [NSPredicate], propertiesToFetch: [String]) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        fetchRequest.predicate = predicate
        fetchRequest.propertiesToFetch = propertiesToFetch
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        do {
            if let results = try context?.fetch(fetchRequest) {
                return results
            }
        }catch {
            print("Failed to fetch transactions: \(error)")
        }
        return []
    }
    
    func periodPredict(for dateComponent: Calendar.Component, periodFrom: String) -> NSPredicate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        
        guard let dateFrom = formatter.date(from: "\(periodFrom)"),
            let dateTo = calendar.date(byAdding: dateComponent, value: 1, to: dateFrom) as NSDate? else { return nil }
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", dateFrom as NSDate, dateTo)
        return predicate
    }
    
    func distinctTransactionPeriod(periodFormatPattern: String) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = periodFormatPattern
        
        var transactionDates = transactionDateAndTime
        if periodModel is TransactionWeeklyPeriodModel {
            transactionDates = transactionDateAndTime?.map { (date) -> Date in
                let monday = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))
                return monday ?? date
                }
        }
        guard let periodArray = transactionDates?.map({ formatter.string(from: $0) }),
            let distinctPeriodArray = Array(NSSet(array: periodArray)) as? [String] else {
                return []
        }
        return distinctPeriodArray
    }
    
    func getAllTags(dateRangePredict: NSPredicate?, userId: String, transactionTypeName: String) -> [String] {
        let transactionTypePredict = NSPredicate(format: "transactionType.name == '\(transactionTypeName)'")
        let userPredict = NSPredicate(format: "user.id == '\(userId)'")
        
        var predicts: [NSPredicate] = [userPredict, transactionTypePredict]
        if let predict = dateRangePredict {
            predicts.append(predict)
        }
        guard let tagsDict = searchData(predicts, propertiesToFetch: ["tag.name"]) as? [NSDictionary],
            let tags = Array(tagsDict.compactMap({ $0.allValues }).joined()) as? [String] else {
            return []
        }
        
        return tags.sorted()
    }
    
    func reportSumByUserAndTransaction(with predicate: NSPredicate) -> [Any] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetch.predicate = predicate
        fetch.resultType = .dictionaryResultType
        let sumExpression = NSExpression(format: "sum:(amount)")
        let sumED = NSExpressionDescription()
        sumED.expression = sumExpression
        sumED.name = "sumOfAmount"
        sumED.expressionResultType = .doubleAttributeType
        fetch.propertiesToFetch = ["user.id", "transactionType.name", sumED]
        fetch.propertiesToGroupBy = ["user.id", "transactionType.name"]
        
        let sort = NSSortDescriptor(key: "user.id", ascending: true)
        fetch.sortDescriptors = [sort]
        do {
            if let results = try context?.fetch(fetch) {
                return results
            }
        } catch {
             print("Failed to fetch transactions: \(error)")
        }
        return []
    }
    
    var transactionDateAndTime: [Date]? {
        if allTransactionDates == nil {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
            let sort = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.propertiesToFetch = ["date"]
            fetchRequest.returnsDistinctResults = true
            fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
            
            do {
                let results = try context?.fetch(fetchRequest)
                if let dict = results as? [NSDictionary],
                    let dates = Array(dict.compactMap({ $0.allValues }).joined()) as? [Date] {
                    allTransactionDates = dates
                }
            } catch {
                print("Failed to fetch transaction dates: \(error)")
            }
        }
        
        return allTransactionDates
    }
    
    func allReportModels(from data:[NSDictionary], predict: NSPredicate?) -> [TransactionReportModel] {
        var userData: Dictionary<String, TransactionReportModel>  = Dictionary()
        data.forEach({ (dict) in
            if let userId = dict.value(forKey: "user.id") as? String {
                let transactionTypeName = dict.value(forKey: "transactionType.name") as? String ?? ""
                let sumOfAmount = dict.value(forKey: "sumOfAmount") as? Double ?? 0.0
                
                var reportModel = userData[userId] ?? TransactionReportModel(userId: userId)
                if transactionTypeName == "spending" {
                    reportModel.totalSpending = sumOfAmount
                } else {
                    reportModel.totalSavings = sumOfAmount
                }
                reportModel.tags = getAllTags(dateRangePredict: predict,
                                              userId: userId,
                                              transactionTypeName: transactionTypeName)
                userData[userId] = reportModel
            }
        })
        return Array(userData.values)
    }
}
