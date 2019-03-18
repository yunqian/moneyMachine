//
//  TransactionPeriodModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/17/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

protocol TransactionPeriodModelProtocol {
    var title: String { get }
    
    var periodFormatPattern: String { get }
    
    var calenderComponent: Calendar.Component { get }
    
    func dateFromFormatPattern(with period: String) -> String
    
}

struct TransactionYearlyPeriodModel: TransactionPeriodModelProtocol {
    
    var title: String {
        return "Year: "
    }
    
    var periodFormatPattern: String {
        return "yyyy"
    }
    
    var calenderComponent: Calendar.Component {
        return .year
    }
    
    func dateFromFormatPattern(with period: String) -> String {
        return "\(period)-01-01"
    }
    
}

struct TransactionMonthlyPeriodModel: TransactionPeriodModelProtocol {
    
    var title: String {
        return "Month: "
    }
    
    var periodFormatPattern: String {
        return "yyyy-MM"
    }
    
    var calenderComponent: Calendar.Component {
        return .month
    }
    
    func dateFromFormatPattern(with period: String) -> String {
        return "\(period)-01"
    }
    
}

struct TransactionWeeklyPeriodModel: TransactionPeriodModelProtocol {
    
    var title: String {
        return "Week of "
    }
    
    var periodFormatPattern: String {
        return "yyyy-MM-dd"
    }
    
    var calenderComponent: Calendar.Component {
        return .weekOfYear
    }
    
    func dateFromFormatPattern(with period: String) -> String {
        return "\(period)"
    }
}


struct TransactionDailyPeriodModel: TransactionPeriodModelProtocol {
    
    var title: String {
        return "Date: "
    }
    
    var periodFormatPattern: String {
        return "yyyy-MM-dd"
    }
    
    var calenderComponent: Calendar.Component {
        return .day
    }
    
    func dateFromFormatPattern(with period: String) -> String {
        return "\(period)"
    }
}
