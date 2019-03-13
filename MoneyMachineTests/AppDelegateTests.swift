//
//  AppDelegateTests.swift
//  MoneyMachineTests
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import XCTest

class AppDelegateTests: XCTestCase {

    func testDidFinishLaunchingWithOptions() {
        // Given
        let appDelegate = AppDelegate()
        
        // When
        let didFinishLaunching = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        // Then
        XCTAssertTrue(didFinishLaunching)
        XCTAssertNotNil(appDelegate.persistentContainer)
    }
    
    func testPreLoadData() {
        // Given
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        let appDelegate = FakeAppDelegate(fakePersistentContainer)
        let fakeUserDefault = FakeUserDefault()
        fakeUserDefault.shouldContainValue = false
        
        // When
        appDelegate.preloadDataIfNeeded(userDefaults: fakeUserDefault)
        
        // Then
        XCTAssertTrue(appDelegate.didSaveContext)
        XCTAssertEqual(appDelegate.saveCounter, 12)
        XCTAssertEqual(fakeUserDefault.newKey, "didPreLoad")
        XCTAssertTrue(fakeUserDefault.newValue as? Bool ?? false)
    }
    
    func testSaveContextSuccess() {
        // Given
        let fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        let appDelegate = FakeAppDelegate(fakePersistentContainer)
        appDelegate.shouldTestSuperSave = true
        
        // When
        let saved = appDelegate.saveContext(fakeViewContext)
        
        // Then
        XCTAssertTrue(saved)
        XCTAssertTrue(fakeViewContext.didSave)
    }
    
    func testSaveContextFailure() {
        // Given
        let fakePersistentContainer = FakePersistentContainer(name: "fake")
        let fakeViewContext = FakeManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        fakeViewContext.error = NSError(domain: "error", code: 0, userInfo: [:])
        let appDelegate = FakeAppDelegate(fakePersistentContainer)
        appDelegate.shouldTestSuperSave = true
        
        // When
        let saved = appDelegate.saveContext(fakeViewContext)
        
        // Then
        XCTAssertFalse(saved)
    }
    
    func testDataLoaded() {
        // Given
        let fakePersistentContainer = FakePersistentContainer.init(name: "fake")
        let appDelegate = FakeAppDelegate(fakePersistentContainer)
        let fakeUserDefault = FakeUserDefault()
        fakeUserDefault.shouldContainValue = true
        
        // When
        appDelegate.preloadDataIfNeeded(userDefaults: fakeUserDefault)
        
        // Then
        XCTAssertFalse(appDelegate.didSaveContext)
        XCTAssertEqual(fakeUserDefault.newKey, "")
        XCTAssertNil(fakeUserDefault.newValue)
    }

}
