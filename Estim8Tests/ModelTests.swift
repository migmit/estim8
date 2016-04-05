//
//  ModelTests.swift
//  Estim8
//
//  Created by MigMit on 05/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import XCTest
import CoreData

class ModelTests: XCTestCase {
    
    var model: ModelImplementation? = nil
    
    override func setUp() {
        super.setUp()
        
        do {
            if let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles()){
                if let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel){
                    try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
                    let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                    context.persistentStoreCoordinator = coordinator
                    
                    model = ModelImplementation(managedObjectContext: context)
                }
            }
        } catch {}
        XCTAssertNotNil(model)
    }
    
    override func tearDown() {
        model = nil
        super.tearDown()
    }
    
    func testModelIsEmpty() {
        XCTAssertEqual(model!.liveAccounts(), [])
        XCTAssertEqual(model!.deadAccounts(), [])
        XCTAssertEqual(model!.slices(), [])
    }
    
    func testAddAccount() {
        model!.addAccountAnUpdate("AAA", value: -5, isNegative: true)
        let accounts = model!.liveAccounts()
        XCTAssertEqual(accounts.count, 1)
        let account = accounts[0]
        XCTAssertEqual(model!.nameOfAccount(account), "AAA")
        XCTAssertEqual(model!.accountIsNegative(account), true)
        let updates = model!.updatesOfAccount(account)
        XCTAssertEqual(updates.count, 1)
        let update = updates[0]
        XCTAssertEqual(model!.valueOfUpdate(update), -5)
        model!.removeAccount(account)
        XCTAssertEqual(model!.liveAccounts(), [])
        let deadAccounts = model!.deadAccounts()
        XCTAssertEqual(deadAccounts.count, 1)
        XCTAssertEqual(deadAccounts[0], account)
    }
    
    func testUpdateAccount() {
        let account = model!.addAccountAnUpdate("BBB", value: 3, isNegative: true)
        XCTAssertEqual(model!.liveAccounts().count, 1)
        XCTAssertEqual(model!.updatesOfAccount(account).count, 1)
        model!.updateAccount(account, value: 13)
        let updates = model!.updatesOfAccount(account)
        XCTAssertEqual(updates.count, 2)
        XCTAssertEqual(model!.valueOfUpdate(updates[0]), 13)
        XCTAssertEqual(model!.valueOfUpdate(updates[1]), 3)
        XCTAssertEqual(model!.accountOfUpdate(updates[0]), account)
        XCTAssertEqual(model!.accountOfUpdate(updates[1]), account)
    }
    
    func testMultipleAccounts() {
        let account1 = model!.addAccountAnUpdate("CCC", value: 7, isNegative: false)
        let account2 = model!.addAccountAnUpdate("DDD", value: 8, isNegative: true)
        XCTAssertEqual(model!.nameOfAccount(account1), "CCC")
        XCTAssertEqual(model!.nameOfAccount(account2), "DDD")
        XCTAssertEqual(model!.accountIsNegative(account1), false)
        XCTAssertEqual(model!.accountIsNegative(account2), true)
        XCTAssertNotEqual(account1, account2)
        XCTAssertEqual(model!.liveAccounts().count, 2)
        let updates1 = model!.updatesOfAccount(account1)
        let updates2 = model!.updatesOfAccount(account2)
        XCTAssertEqual(updates1.count, 1)
        XCTAssertEqual(updates2.count, 1)
        XCTAssertEqual(model!.valueOfUpdate(updates1[0]), 7)
        XCTAssertEqual(model!.valueOfUpdate(updates2[0]), 8)
    }
    
    func testCreateSlice() {
        let account = model!.addAccountAnUpdate("EEE", value: 9, isNegative: false)
        let slice = model!.createSlice()
        XCTAssertEqual(model!.slices(),[slice])
        model!.updateAccount(account, value: 19)
        let updates = model!.lastUpdatesOfSlice(slice)
        XCTAssertEqual(updates.count, 1)
        XCTAssertEqual(model!.valueOfUpdate(updates[0]), 9)
    }
    
    func testMultipleSlices() {
        let account = model!.addAccountAnUpdate("FFF", value: 2, isNegative: false)
        let slice1 = model!.createSlice()
        model!.updateAccount(account, value: 12)
        let slice2 = model!.createSlice()
        model!.updateAccount(account, value: 22)
        XCTAssertEqual(model!.slices(), [slice2, slice1])
        XCTAssertNotEqual(slice1, slice2)
        let updates1 = model!.lastUpdatesOfSlice(slice1)
        let updates2 = model!.lastUpdatesOfSlice(slice2)
        XCTAssertEqual(updates1.count, 1)
        XCTAssertEqual(updates2.count, 1)
        XCTAssertEqual(model!.valueOfUpdate(updates1[0]), 2)
        XCTAssertEqual(model!.valueOfUpdate(updates2[0]), 12)
    }
    
    func testDeleteSlice() {
        let slice1 = model!.createSlice()
        XCTAssertEqual(model!.slices(), [slice1])
        let slice2 = model!.createSlice()
        XCTAssertEqual(model!.slices(), [slice2, slice1])
        model!.removeSlice(slice1)
        XCTAssertEqual(model!.slices(), [slice2])
    }
    
    func testDates() {
        let t1 = NSDate()
        let account = model!.addAccountAnUpdate("GGG", value: 4, isNegative: false)
        let t2 = model!.dateOfUpdate(model!.updatesOfAccount(account)[0])
        let t2_ = model!.accountOpenDate(account)
        let tnil = model!.accountClosingDate(account)
        let t3 = NSDate()
        model!.updateAccount(account, value: 14)
        let t4 = model!.dateOfUpdate(model!.updatesOfAccount(account)[0])
        let t5 = NSDate()
        let slice = model!.createSlice()
        let t6 = model!.dateOfSlice(slice)
        let t7 = NSDate()
        model!.removeAccount(account)
        let t8 = model!.accountClosingDate(account)
        let t9 = NSDate()
        XCTAssertNotEqual(t1.compare(t2), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t1.compare(t2_), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t2.compare(t3), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t2_.compare(t3), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t3.compare(t4), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t4.compare(t5), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t5.compare(t6), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t6.compare(t7), NSComparisonResult.OrderedDescending)
        XCTAssertNotNil(t8)
        XCTAssertNotEqual(t7.compare(t8!), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t8!.compare(t9), NSComparisonResult.OrderedDescending)
        XCTAssertNil(tnil)
    }
}
