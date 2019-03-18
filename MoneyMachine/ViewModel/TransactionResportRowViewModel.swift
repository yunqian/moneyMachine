//
//  TransactionResportRowViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/17/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

struct TransactionResportRowViewModel {

    private let reportModel: TransactionReportModel
    
    init(reportModel: TransactionReportModel = TransactionReportModel(userId: "")) {
        self.reportModel = reportModel
    }
    
    var userId: String {
        return reportModel.userId
    }
    
    var totalSpending: String {
        return "$\(String(format: "%.2f", reportModel.totalSpending))"
    }
    
    var totalSavings: String {
        return "$\(String(format: "%.2f", reportModel.totalSavings))"
    }
    
    var tags: String {
        return reportModel.tags.joined(separator: ", ")
    }
}
