//
//  TransactionBaseInfoViewModel.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

class TransactionBaseInfoViewModel: TransactionBaseInfoProtocol {
    
    private (set) var context: NSManagedObjectContext?
    private (set) var appDelegate: AppDelegate?
    
    init(appDelegate: UIApplicationDelegate? = UIApplication.shared.delegate) {
        if let appDelegate = appDelegate as? AppDelegate {
            self.appDelegate = appDelegate
            context = appDelegate.persistentContainer.viewContext
        }
    }
    
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
