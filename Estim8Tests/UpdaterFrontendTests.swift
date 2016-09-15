//
//  UpdaterFrontendTests.swift
//  Estim8
//
//  Created by MigMit on 18/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import XCTest
import CoreData

class UpdaterFrontendTests: XCTestCase {

    var model: ModelImplementation? = nil
    
    override func setUp() {
        super.setUp()
        
        let defaults = UserDefaults.standard
        let dict = defaults.dictionaryRepresentation()
        for (key, _) in dict {
            defaults.removeObject(forKey: key)
        }
        
        do {
            if let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil){
                if let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel){
                    try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
                    let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
                    context.persistentStoreCoordinator = coordinator
                    
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
    
    func testUpdatingOnce() {
        XCTAssertNil(UserDefaults.standard.object(forKey: "updater.lastUpdate"))
        let euroCurrency = model!.addCurrencyAndUpdate("Euro", code: "EUR", symbol: "€", base: nil, rate: 1, invRate: 1, manual: true)
        let backend = UpdaterBackendMoc()
        backend.exchangeRates = ["EUR" : (2,0.5), "USD" : (0.5, 2)]
        let updater = UpdaterFrontendImpl(model: model!, updateInterval: 60*60, sinceLastUpdate: 60*60, backend: backend)
        updater.startUpdating()
        updater.stopUpdating()
        RunLoop.main.run(until: Date().addingTimeInterval(1))
        XCTAssertEqual(model!.liveCurrencies().count, 1)
        let updates = model!.updatesOfCurrency(euroCurrency)
        XCTAssertEqual(updates.count, 2)
        let rate = model!.rateOfCurrencyUpdate(updates[0])
        XCTAssertEqual(rate.0, 2)
        XCTAssertEqual(rate.1, 0.5)
    }
    
    func testUpdatingDependent() {
        let euroCurrency = model!.addCurrencyAndUpdate("Euro", code: "EUR", symbol: "€", base: nil, rate: 1, invRate: 1, manual: true)
        let dollarCurrency = model!.addCurrencyAndUpdate("US Dollar", code: "USD", symbol: "$", base: euroCurrency, rate: 0.5, invRate: 2, manual: true)
        let backend = UpdaterBackendMoc()
        backend.exchangeRates = ["EUR" : (1.6, 0.625), "USD" : (0.8, 1.25)]
        let updater = UpdaterFrontendImpl(model: model!, updateInterval: 60*60, sinceLastUpdate: 60*60, backend: backend)
        updater.startUpdating()
        updater.stopUpdating()
        RunLoop.main.run(until: Date().addingTimeInterval(1))
        XCTAssertEqual(model!.liveCurrencies().count, 2)
        let euroUpdates = model!.updatesOfCurrency(euroCurrency)
        XCTAssertEqual(euroUpdates.count, 2)
        let euroRate = model!.rateOfCurrencyUpdate(euroUpdates[0])
        XCTAssertEqual(euroRate.0, 1.6)
        let dollarUpdates = model!.updatesOfCurrency(dollarCurrency)
        XCTAssertEqual(dollarUpdates.count, 2)
        let dollarRate = model!.rateOfCurrencyUpdate(dollarUpdates[0])
        XCTAssertEqual(dollarRate.0, 0.8)
        XCTAssertNil(model!.currenciesOfUpdate(dollarUpdates[0]).1)
    }
    
    func testUpdateTwice() {
        let euroCurrency = model!.addCurrencyAndUpdate("Euro", code: "EUR", symbol: "€", base: nil, rate: 1, invRate: 1, manual: true)
        let backend = UpdaterBackendMoc()
        backend.exchangeRates = ["EUR": (2.5, 0.4)]
        let updater = UpdaterFrontendImpl(model: model!, updateInterval: 1, sinceLastUpdate: 0.5, backend: backend)
        updater.startUpdating()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))
        XCTAssertEqual(model!.liveCurrencies().count, 1)
        let updates = model!.updatesOfCurrency(euroCurrency)
        XCTAssertEqual(updates.count, 2)
        let rate = model!.rateOfCurrencyUpdate(updates[0])
        XCTAssertEqual(rate.0, 2.5)
        backend.exchangeRates = ["EUR" : (5, 0.2)]
        RunLoop.main.run(until: Date().addingTimeInterval(1.1))
        updater.stopUpdating()
        let newUpdates = model!.updatesOfCurrency(euroCurrency)
        XCTAssertEqual(newUpdates.count, 3)
        let newRate = model!.rateOfCurrencyUpdate(newUpdates[0])
        XCTAssertEqual(newRate.0, 5)
    }
    
}
