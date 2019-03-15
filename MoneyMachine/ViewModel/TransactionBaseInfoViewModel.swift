//
//  TransactionBaseInfoViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

class TransactionBaseInfoViewModel: NSObject, TransactionBaseInfoProtocol {
    
    private static let shared: TransactionBaseInfoViewModel = TransactionBaseInfoViewModel()
    private (set) var context: NSManagedObjectContext?
    
    static func sharedInstance(appDelegate: UIApplicationDelegate? = nil) -> TransactionBaseInfoViewModel {
        if let appDelegate = appDelegate as? AppDelegate {
            shared.context = appDelegate.persistentContainer.viewContext
        }
        return shared
    }
    
    init(appDelegate: UIApplicationDelegate? = UIApplication.shared.delegate) {
        if let appDelegate = appDelegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
    }
    
    lazy var userCount: Int = {
        return users.count
    }()
    
    lazy var tagCount: Int = {
        return tags.count
    }()
    
    lazy var users: [User] = {
        guard let allUsers = fetchEntity("User") as? [User] else { return [] }
        return allUsers
    }()
    
    lazy var tags: [Tag] = {
        guard let allTags = fetchEntity("Tag") as? [Tag] else { return [] }
        return allTags
    }()
    
    lazy var transactionTypes: [TransactionType] = {
        guard let allTypes = fetchEntity("TransactionType") as? [TransactionType] else { return [] }
        return allTypes
    }()
    
    private func fetchEntity(_ entityName: String) -> [Any] {
        guard let context = context else { return [] }
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try context.fetch(fetch)
        } catch {
            print("Failed to fetch transactionType: \(error)")
        }
        return []
    }
    
}

class TransactionBaseViewModel: NSObject, TransactionBaseInfoProtocol {
    
    private (set) var baseInfoViewModel: TransactionBaseInfoProtocol = TransactionBaseInfoViewModel.sharedInstance()
    
    init(baseInfoViewModel: TransactionBaseInfoProtocol = TransactionBaseInfoViewModel.sharedInstance()) {
        self.baseInfoViewModel = baseInfoViewModel
    }
    
    var userCount: Int {
        return baseInfoViewModel.userCount
    }
    
    var tagCount: Int {
        return baseInfoViewModel.tagCount
    }
    
    var users: [User] {
        return baseInfoViewModel.users
    }
    
    var tags: [Tag] {
        return baseInfoViewModel.tags
    }
    
    var transactionTypes: [TransactionType] {
        return baseInfoViewModel.transactionTypes
    }
    
    var context: NSManagedObjectContext? {
        return baseInfoViewModel.context
    }
    
}
