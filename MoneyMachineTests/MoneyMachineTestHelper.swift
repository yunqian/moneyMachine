//
//  MoneyMachineTestHelper.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest
import CoreData

class FakePersistentContainer: NSPersistentContainer {
    
    var fakeViewContext: FakeManagedObjectContext? // = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
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
    
    override func save() throws {
        if let error = error {
            throw error
        } else {
             didSave = true
        }
    }
   
    override func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
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

class FakeManagedObjectModel: NSManagedObjectModel {
    
}

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

class FakeTransactionViewModel: TransactionViewModel {

    override var users: [User] {
        get {
            let fakeUser1 = FakeUser()
            fakeUser1.testId = "001"
            let fakeUser2 = FakeUser()
            fakeUser2.testId = "002"
            return [fakeUser1, fakeUser2]
            
        }
        set { }
    }
    
    override var tags: [Tag] {
        get {
            let fakeTag1 = FakeTag()
            fakeTag1.testName = "tag1"
            let fakeTag2 = FakeTag()
            fakeTag2.testName = "tag2"
            let fakeTag3 = FakeTag()
            fakeTag3.testName = "tag3"
            return [fakeTag1, fakeTag2, fakeTag3]
            
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

class TestTransactionViewModel: FakeTransactionViewModel {
    var processSuccuss: Bool = true

    override func processTransaction(with userIndex: Int, moneyTransactionType: MoneyTransactionType, amount: String, description: String, tagIndex: Int) -> Bool {
        return processSuccuss
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
