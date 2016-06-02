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
            if let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil){
                if let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel){
                    try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
                    let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                    context.persistentStoreCoordinator = coordinator
                    
                    let currency: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: context)
                    let currencyUpdate = NSEntityDescription.insertNewObjectForEntityForName("CurrencyUpdate", inManagedObjectContext: context)
                    currency.setValue("USD", forKey: "code")
                    currency.setValue("United States Dollar", forKey: "name")
                    currency.setValue("$", forKey: "symbol")
                    currency.setValue(0, forKey: "sortingIndex")
                    currency.setValue(NSDate(), forKey: "addDate")
                    currency.setValue(false, forKey: "removed")
                    currency.setValue(Set<NSManagedObject>(), forKey: "updates")
                    currency.setValue(Set<NSManagedObject>(), forKey: "based")
                    currencyUpdate.setValue(NSDate(), forKey: "date")
                    currencyUpdate.setValue(1, forKey: "rate")
                    currencyUpdate.setValue(1, forKey: "inverseRate")
                    currencyUpdate.setValue(true, forKey: "manual")
                    currencyUpdate.setValue(currency, forKey: "base")
                    currencyUpdate.setValue(currency, forKey: "currency")
                    currencyUpdate.setValue(Set<NSManagedObject>(), forKey: "updates")
                    
                    do {try context.save()} catch {}

                    model = ModelImplementation(managedObjectContext: context)
                }
            }
        } catch {
            XCTFail()
        }
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
        model!.addAccountAndUpdate("AAA", value: -5, isNegative: true, currency: model!.baseCurrency())
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
        let account = model!.addAccountAndUpdate("BBB", value: 3, isNegative: true, currency: model!.baseCurrency())
        XCTAssertEqual(model!.liveAccounts().count, 1)
        XCTAssertEqual(model!.updatesOfAccount(account).count, 1)
        model!.updateAccount(account, value: 13, currency: model!.baseCurrency())
        let updates = model!.updatesOfAccount(account)
        XCTAssertEqual(updates.count, 2)
        XCTAssertEqual(model!.valueOfUpdate(updates[0]), 13)
        XCTAssertEqual(model!.valueOfUpdate(updates[1]), 3)
        XCTAssertEqual(model!.accountOfUpdate(updates[0]), account)
        XCTAssertEqual(model!.accountOfUpdate(updates[1]), account)
    }
    
    func testMultipleAccounts() {
        let account1 = model!.addAccountAndUpdate("CCC", value: 7, isNegative: false, currency: model!.baseCurrency())
        let account2 = model!.addAccountAndUpdate("DDD", value: 8, isNegative: true, currency: model!.baseCurrency())
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
        let account = model!.addAccountAndUpdate("EEE", value: 9, isNegative: false, currency: model!.baseCurrency())
        let slice = model!.createSlice()
        XCTAssertEqual(model!.slices(),[slice])
        model!.updateAccount(account, value: 19, currency: model!.baseCurrency())
        let updates = model!.lastUpdatesOfSlice(slice)
        XCTAssertEqual(updates.count, 1)
        XCTAssertEqual(model!.valueOfUpdate(updates[0]), 9)
    }
    
    func testMultipleSlices() {
        let account = model!.addAccountAndUpdate("FFF", value: 2, isNegative: false, currency: model!.baseCurrency())
        let slice1 = model!.createSlice()
        model!.updateAccount(account, value: 12, currency: model!.baseCurrency())
        let slice2 = model!.createSlice()
        model!.updateAccount(account, value: 22, currency: model!.baseCurrency())
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
        let account = model!.addAccountAndUpdate("GGG", value: 4, isNegative: false, currency: model!.baseCurrency())
        let t2 = model!.dateOfUpdate(model!.updatesOfAccount(account)[0])
        let t2_ = model!.accountOpenDate(account)
        let tnil = model!.accountClosingDate(account)
        let t3 = NSDate()
        model!.updateAccount(account, value: 14, currency: model!.baseCurrency())
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
    
    func testBaseCurrency() {
        let c = model!.baseCurrency()
        XCTAssertEqual(model!.codeOfCurrency(c), "USD")
        XCTAssertEqual(model!.symbolOfCurrency(c), "$")
        let us = model!.updatesOfCurrency(c)
        XCTAssertEqual(us.count, 1)
        let u = us[0]
        XCTAssert(model!.currencyUpdateIsManual(u))
        let rates = model!.rateOfCurrencyUpdate(u)
        XCTAssertEqual(rates.0, 1)
        XCTAssertEqual(rates.1, 1)
        let currs = model!.currenciesOfUpdate(u)
        XCTAssertEqual(currs.0, c)
        XCTAssertEqual(currs.1, c)
        XCTAssertEqual(model!.liveCurrencies(), [c])
    }
    
    func testAddCurrency() {
        let c = model!.addCurrencyAndUpdate("Fictional", code: "FCT", symbol: "F", base: model!.baseCurrency(), rate: 2, invRate: 0.5, manual: false)
        XCTAssertEqual(model!.codeOfCurrency(c), "FCT")
        XCTAssertEqual(model!.symbolOfCurrency(c), "F")
        let us = model!.updatesOfCurrency(c)
        XCTAssertEqual(us.count, 1)
        let u = us[0]
        XCTAssert(!model!.currencyUpdateIsManual(u))
        let rates = model!.rateOfCurrencyUpdate(u)
        XCTAssertEqual(rates.0, 2)
        XCTAssertEqual(rates.1, 0.5)
        let currs = model!.currenciesOfUpdate(u)
        XCTAssertEqual(currs.0, c)
        XCTAssertEqual(currs.1, model!.baseCurrency())
        XCTAssertEqual(model!.liveCurrencies(), [model!.baseCurrency(), c])
    }
    
    func testUpdateCurrency() {
        let c = model!.addCurrencyAndUpdate("Fictional", code: "FCT", symbol: "F", base: model!.baseCurrency(), rate: 2, invRate: 0.5, manual: false)
        model!.updateCurrency(c, base: model!.baseCurrency(), rate: 4, invRate: 0.25, manual: true)
        XCTAssertEqual(model!.codeOfCurrency(c), "FCT")
        XCTAssertEqual(model!.symbolOfCurrency(c), "F")
        let us = model!.updatesOfCurrency(c)
        XCTAssertEqual(us.count, 2)
        let u = us[0]
        XCTAssert(model!.currencyUpdateIsManual(u))
        let rates = model!.rateOfCurrencyUpdate(u)
        XCTAssertEqual(rates.0, 4)
        XCTAssertEqual(rates.1, 0.25)
        let currs = model!.currenciesOfUpdate(u)
        XCTAssertEqual(currs.0, c)
        XCTAssertEqual(currs.1, model!.baseCurrency())
        XCTAssertEqual(model!.liveCurrencies(), [model!.baseCurrency(), c])
    }
    
    func testMultipleCurrencies() {
        let c1 = model!.addCurrencyAndUpdate("Fictional", code: "FCT", symbol: "F", base: model!.baseCurrency(), rate: 2, invRate: 0.5, manual: false)
        let c2 = model!.addCurrencyAndUpdate("Imaginary", code: "IMG", symbol: "I", base: model!.baseCurrency(), rate: 5, invRate: 0.2, manual: false)
        XCTAssertEqual(model!.codeOfCurrency(c2), "IMG")
        XCTAssertEqual(model!.symbolOfCurrency(c2), "I")
        let us = model!.updatesOfCurrency(c1)
        XCTAssertEqual(us.count, 1)
        let u = us[0]
        XCTAssert(!model!.currencyUpdateIsManual(u))
        let rates = model!.rateOfCurrencyUpdate(u)
        XCTAssertEqual(rates.0, 2)
        XCTAssertEqual(rates.1, 0.5)
        let currs = model!.currenciesOfUpdate(u)
        XCTAssertEqual(currs.0, c1)
        XCTAssertEqual(currs.1, model!.baseCurrency())
        XCTAssertEqual(model!.liveCurrencies(), [model!.baseCurrency(), c1, c2])
        model!.updateCurrency(c1, base: c2, rate: 10, invRate: 0.1, manual: true)
        XCTAssertEqual(model!.codeOfCurrency(c1), "FCT")
        XCTAssertEqual(model!.symbolOfCurrency(c1), "F")
        let us1 = model!.updatesOfCurrency(c1)
        XCTAssertEqual(us1.count, 2)
        let u1 = us1[0]
        XCTAssert(model!.currencyUpdateIsManual(u1))
        let rates1 = model!.rateOfCurrencyUpdate(u1)
        XCTAssertEqual(rates1.0, 10)
        XCTAssertEqual(rates1.1, 0.1)
        let currs1 = model!.currenciesOfUpdate(u1)
        XCTAssertEqual(currs1.0, c1)
        XCTAssertEqual(currs1.1, c2)
        XCTAssertEqual(model!.liveCurrencies(), [model!.baseCurrency(), c1, c2])
        model!.removeCurrency(c1)
        XCTAssertEqual(model!.liveCurrencies(), [model!.baseCurrency(), c2])
    }
    
    func testAccountCurrency() {
        let a = model!.addAccountAndUpdate("AAA", value: 1, isNegative: false, currency: model!.baseCurrency())
        let us = model!.updatesOfAccount(a)
        XCTAssertEqual(us.count, 1)
        let u = us[0]
        XCTAssertEqual(model!.currencyOfUpdate(u), model!.baseCurrency())
        let c = model!.addCurrencyAndUpdate("Fictional", code: "FCT", symbol: "F", base: model!.baseCurrency(), rate: 2, invRate: 0.5, manual: false)
        model?.updateAccount(a, value: 2, currency: c)
        let us1 = model!.updatesOfAccount(a)
        XCTAssertEqual(us1.count, 2)
        let u1 = us1[0]
        XCTAssertEqual(model!.currencyOfUpdate(u1), c)
    }
    
    func testCurrenciesDates() {
        let a = model!.addAccountAndUpdate("AAA", value: 1, isNegative: false, currency: model!.baseCurrency())
        let t1 = NSDate()
        let c = model!.addCurrencyAndUpdate("Fictional", code: "FCT", symbol: "F", base: model!.baseCurrency(), rate: 2, invRate: 0.5, manual: true)
        let t2 = model!.currencyAddDate(c)
        let us = model!.updatesOfCurrency(c)
        XCTAssertEqual(us.count, 1)
        let u = us[0]
        let t2_ = model!.dateOfCurrencyUpdate(u)
        let tnil = model!.currencyRemoveDate(c)
        let t3 = NSDate()
        model!.updateAccount(a, value: 2, currency: c)
        let t4 = model!.dateOfUpdate(model!.updatesOfAccount(a)[0])
        let t5 = NSDate()
        model!.updateCurrency(c, base: model!.baseCurrency(), rate: 4, invRate: 0.25, manual: false)
        let us1 = model!.updatesOfCurrency(c)
        XCTAssertEqual(us1.count, 2)
        let u1 = us1[0]
        let t6 = model!.dateOfCurrencyUpdate(u1)
        let t7 = NSDate()
        model!.removeCurrency(c)
        let t8 = model!.currencyRemoveDate(c)
        let t9 = NSDate()
        XCTAssertNotEqual(t1.compare(t2), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t1.compare(t2_), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t2.compare(t3), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t2_.compare(t3), NSComparisonResult.OrderedDescending)
        XCTAssertNil(tnil)
        XCTAssertNotEqual(t3.compare(t4), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t4.compare(t5), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t5.compare(t6), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t6.compare(t7), NSComparisonResult.OrderedDescending)
        XCTAssertNotNil(t8)
        XCTAssertNotEqual(t7.compare(t8!), NSComparisonResult.OrderedDescending)
        XCTAssertNotEqual(t8!.compare(t9), NSComparisonResult.OrderedDescending)
    }
}
