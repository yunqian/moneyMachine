//
//  TransactionReportModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/16/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

struct TransactionReportModel {
    var userId: String
    var totalSpending: Double
    var totalSavings: Double
    var tags: [String]
    
    init(userId: String,
         totalSpending: Double = 0.0,
         totalSavings: Double = 0.0,
         tags: [String] = []) {
        self.userId = userId
        self.totalSpending = totalSpending
        self.totalSavings = totalSavings
        self.tags = tags
    }
}
