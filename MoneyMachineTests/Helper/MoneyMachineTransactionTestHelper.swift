//
//  MoneyMachineTestHelper.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

class FakeTransactionBaseInfoViewModel: TransactionBaseInfoViewModel {
    
    override var userCount: Int {
        get {
            return 2
        }
        set { }
    }
    
    override var tagCount: Int {
        get {
            return 3
        }
        set { }
    }
    
    override var users: [User] {
        get {
            let fakeUser1 = FakeUser()
            fakeUser1.testId = "001"
            let fakeUser2 = FakeUser()
            fakeUser2.testId = "002"
            let fakeUser3 = FakeUser()
            fakeUser3.testId = "003"
            return [fakeUser1, fakeUser2, fakeUser3]
        }
        set { }
    }
    
    override var transactionTypes: [TransactionType] {
        get {
            let fakeType1 = FakeTransactionType()
            fakeType1.testName = "spending"
            let fakeType2 = FakeTransactionType()
            fakeType2.testName = "saving"
            return [fakeType1, fakeType2]
        }
        set { }
    }
}

class FakeTransactionViewModel: TransactionViewModel {

    override var userCount: Int {
        return users.count
    }
    
    override var users: [User] {
        let fakeUser1 = FakeUser()
        fakeUser1.testId = "001"
        let fakeUser2 = FakeUser()
        fakeUser2.testId = "002"
        return [fakeUser1, fakeUser2]
    }
    
    override var tagCount: Int {
        return tags.count
    }
    
    override var tags: [Tag] {
        let fakeTag1 = FakeTag()
        fakeTag1.testName = "tag1"
        let fakeTag2 = FakeTag()
        fakeTag2.testName = "tag2"
        let fakeTag3 = FakeTag()
        fakeTag3.testName = "tag3"
        return [fakeTag1, fakeTag2, fakeTag3]
    }
    
    override var transactionTypes: [TransactionType] {
        get {
            let fakeType1 = FakeTransactionType()
            fakeType1.testName = "spending"
            let fakeType2 = FakeTransactionType()
            fakeType2.testName = "saving"
            return [fakeType1, fakeType2]
        }
        set { }
    }
    
}

class TestTransactionViewModel: FakeTransactionViewModel {
    var processSuccuss: Bool = true

    override func processTransaction(with userIndex: Int, moneyTransactionType: MoneyTransactionType, amount: String, description: String, tagIndex: Int) -> Bool {
        return processSuccuss
    }
}

class FakeTransactionSearchViewModel: TransactionSearchViewModel {
    
    let fakeTransactions = [FakeTransaction(context: FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))]
    
    override func searchTransaction(transactionTypeIndex: Int, userIdIndex: Int, tagNameIndex: Int, date: Date) -> [TransactionProtocol] {
        return fakeTransactions
    }
}

extension TransactionSearchResultTableViewCell {
    static func testSubject() -> TransactionSearchResultTableViewCell {
        let subject = TransactionSearchResultTableViewCell(style: .default, reuseIdentifier: "TransactionSearchResultTableViewCell")
        subject.userLabel = UILabel()
        subject.amountLabel = UILabel()
        subject.tagLabel = UILabel()
        subject.descriptionLabel = UILabel()
        subject.dateLabel = UILabel()
        return subject
    }
}

extension TransactionReportTableViewCell {
    static func testSubject() -> TransactionReportTableViewCell {
        let subject = TransactionReportTableViewCell(style: .default, reuseIdentifier: "TransactionReportTableViewCell")
        subject.userLabel = UILabel()
        subject.totalSavingsLabel = UILabel()
        subject.totalSpendingLabel = UILabel()
        subject.tagsLabel = UILabel()
        return subject
    }
}

class FakeTransactionReportViewModel: TransactionReportProtocol {
    var updateIndex: Int = -1
    var didUpdatePeriodModel: Bool = false
    var testTransactionResportRowViewModel: TransactionResportRowViewModel = TransactionResportRowViewModel()
    
    var numbersOfReportSection: Int {
        return 1
    }
    
    func rowNumbersOfReportSection(section: Int) -> Int {
        return 2
    }
    
    func reportSectionTitle(section: Int) -> String {
        return "test title"
    }
    
    func reportRowViewModel(at indexPath: IndexPath) -> TransactionResportRowViewModel {
        return testTransactionResportRowViewModel
    }
    
    func updatePeriodModel(at index: Int) {
        didUpdatePeriodModel = true
        updateIndex = index
    }
}
