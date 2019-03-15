//
//  CommonTestHelper.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit
import CoreData

class FakePersistentContainer: NSPersistentContainer {
    
    var fakeViewContext: FakeManagedObjectContext?
    
    override var viewContext: NSManagedObjectContext {
        if let fakeViewContext = fakeViewContext {
            return fakeViewContext
        }
        return super.viewContext
    }
    
    init(name: String) {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        super.init(name: name, managedObjectModel: managedObjectModel)
    }
    
}

class FakeManagedObjectContext: NSManagedObjectContext {
    var didSave: Bool = false
    var fetchResult: [Any] = []
    var error: NSError? = nil
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    override func save() throws {
        if let error = error {
            throw error
        } else {
            didSave = true
        }
    }
    
    override func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
        fetchRequest = request
        if let error = error {
            throw error
        } else {
            return fetchResult
        }
    }
}

class FakeAppDelegate: AppDelegate {
    var didSaveContext: Bool = false
    var saveCounter: Int = 0
    var didPreLoadData: Bool = false
    var fakePersistentContainer: FakePersistentContainer?
    var shouldTestSuperSave: Bool = false
    
    init(_ persistentContainer: FakePersistentContainer?) {
        fakePersistentContainer = persistentContainer
        super.init()
    }
    
    override var persistentContainer: NSPersistentContainer {
        get {
            if let testPersistentContainer = fakePersistentContainer {
                return testPersistentContainer
            }
            return super.persistentContainer
            
        }
        set { }
    }
    
    override func preloadDataIfNeeded(userDefaults: UserDefaults) {
        didPreLoadData = true
        super.preloadDataIfNeeded(userDefaults: userDefaults)
    }
    
    override func saveContext(_ context: NSManagedObjectContext) -> Bool {
        didSaveContext = true
        saveCounter += 1
        if shouldTestSuperSave {
            return super.saveContext(context)
        }
        return true
    }
    
}

class FakeUserDefault: UserDefaults {
    
    var shouldContainValue: Bool = false
    var newKey: String = ""
    var newValue: Any?
    
    override func bool(forKey defaultName: String) -> Bool {
        return shouldContainValue
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        newKey = defaultName
        newValue = value
    }
    
}

class FakeManagedObjectModel: NSManagedObjectModel { }

class FakeStoryboardSegue: UIStoryboardSegue {
    
    var fakeIdentifier: String?
    var fakeDestinationViewController: UIViewController = UIViewController()
    
    override var destination: UIViewController {
        return fakeDestinationViewController
    }
    
    override var identifier: String? {
        return fakeIdentifier
    }
}

class FakeUser: User {
    var testId: String = ""
    
    override var id: String? {
        get {
            return testId
        }
        set {}
    }
}

class FakeTransactionType: TransactionType {
    var testName: String = ""
    
    override var name: String? {
        get {
            return testName
        }
        set {}
    }
}

class FakeTag: Tag {
    var testName: String = ""
    
    override var name: String? {
        get {
            return testName
        }
        set {}
    }
}

class FakeTransaction: NSObject, TransactionProtocol {
    
    var testUser: User?
    var testTag: Tag?
    var testTransactionType: TransactionType?
    
    var amount: Double = 0.0
    var note: String? = ""
    var date: Date? = nil
    
    var user: User? {
        get {
            return testUser
        }
        set {
            testUser = newValue
        }
    }
    
    var tag: Tag? {
        get {
            return testTag
        }
        set {
            testTag = newValue
        }
    }
    
    var transactionType: TransactionType? {
        get {
            return testTransactionType
        }
        set {
            testTransactionType = newValue
        }
    }
    
    required init(context moc: NSManagedObjectContext){
        super.init()
    }
}


class FakeView: UIView {
    
    var gesture: UITapGestureRecognizer?
    var gestureRecognizerAdded: Bool = false
    var editingEnded: Bool = false
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        gestureRecognizerAdded = true
        gesture = gestureRecognizer as? UITapGestureRecognizer
        super.addGestureRecognizer(gestureRecognizer)
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        if force {
            editingEnded = true
        }
        return super.endEditing(force)
    }
}

class FakePickerView: UIPickerView {
    
    override func selectedRow(inComponent component: Int) -> Int {
        return 0
    }
}
