//
//  CurrenciesUpdateToUpdate.swift
//  Estim8
//
//  Created by MigMit on 17/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation
import CoreData

class CurrenciesUpdateToUpdate: NSEntityMigrationPolicy {
    
    var currencyUpdate: NSManagedObject? = nil
    
    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        let destinationContext: NSManagedObjectContext = manager.destinationContext
        let currency: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Currency", into: destinationContext)
        currencyUpdate = NSEntityDescription.insertNewObject(forEntityName: "CurrencyUpdate", into: destinationContext)
        currency.setValue("USD", forKey: "code")
        currency.setValue("United States Dollar", forKey: "name")
        currency.setValue("$", forKey: "symbol")
        currency.setValue(0, forKey: "sortingIndex")
        currency.setValue(Date(), forKey: "addDate")
        currency.setValue(false, forKey: "removed")
        currency.setValue(Set<NSManagedObject>(), forKey: "updates")
        currency.setValue(Set<NSManagedObject>(), forKey: "based")
        currencyUpdate!.setValue(Date(), forKey: "date")
        currencyUpdate!.setValue(1, forKey: "rate")
        currencyUpdate!.setValue(1, forKey: "inverseRate")
        currencyUpdate!.setValue(true, forKey: "manual")
        currencyUpdate!.setValue(false, forKey: "obsolete")
        currencyUpdate!.setValue(nil, forKey: "base")
        currencyUpdate!.setValue(currency, forKey: "currency")
        currencyUpdate!.setValue(Set<NSManagedObject>(), forKey: "updates")
    }
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinationContext: NSManagedObjectContext = manager.destinationContext
        if let dName = mapping.destinationEntityName {
            let dInstance: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: dName, into: destinationContext)
            dInstance.setValue(sInstance.value(forKey: "date"), forKey: "date")
            dInstance.setValue(sInstance.value(forKey: "value"), forKey: "value")
            let migratedAccount = manager.destinationInstances(forEntityMappingName: "AccountToAccount", sourceInstances: [sInstance.value(forKey: "account") as! NSManagedObject])
            dInstance.setValue(migratedAccount[0], forKey: "account")
            let sourceSlices: Set<NSManagedObject> = sInstance.value(forKey: "slices") as! Set<NSManagedObject>
            let migratedSlices = manager.destinationInstances(forEntityMappingName: "SliceToSlice", sourceInstances: Array(sourceSlices))
            dInstance.setValue(Set(migratedSlices), forKey: "slices")
            dInstance.setValue(currencyUpdate!, forKey: "currencyUpdate")
            manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
        }
    }
    
}
