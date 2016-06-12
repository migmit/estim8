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
    
    override func beginEntityMapping(mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinationContext: NSManagedObjectContext = manager.destinationContext
        let currency: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: destinationContext)
        currencyUpdate = NSEntityDescription.insertNewObjectForEntityForName("CurrencyUpdate", inManagedObjectContext: destinationContext)
        currency.setValue("USD", forKey: "code")
        currency.setValue("United States Dollar", forKey: "name")
        currency.setValue("$", forKey: "symbol")
        currency.setValue(0, forKey: "sortingIndex")
        currency.setValue(NSDate(), forKey: "addDate")
        currency.setValue(false, forKey: "removed")
        currency.setValue(Set<NSManagedObject>(), forKey: "updates")
        currency.setValue(Set<NSManagedObject>(), forKey: "based")
        currencyUpdate!.setValue(NSDate(), forKey: "date")
        currencyUpdate!.setValue(1, forKey: "rate")
        currencyUpdate!.setValue(1, forKey: "inverseRate")
        currencyUpdate!.setValue(true, forKey: "manual")
        currencyUpdate!.setValue(false, forKey: "obsolete")
        currencyUpdate!.setValue(nil, forKey: "base")
        currencyUpdate!.setValue(currency, forKey: "currency")
        currencyUpdate!.setValue(Set<NSManagedObject>(), forKey: "updates")
    }
    
    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinationContext: NSManagedObjectContext = manager.destinationContext
        if let dName = mapping.destinationEntityName {
            let dInstance: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(dName, inManagedObjectContext: destinationContext)
            dInstance.setValue(sInstance.valueForKey("date"), forKey: "date")
            dInstance.setValue(sInstance.valueForKey("value"), forKey: "value")
            let migratedAccount = manager.destinationInstancesForEntityMappingNamed("AccountToAccount", sourceInstances: [sInstance.valueForKey("account") as! NSManagedObject])
            dInstance.setValue(migratedAccount[0], forKey: "account")
            let sourceSlices: Set<NSManagedObject> = sInstance.valueForKey("slices") as! Set<NSManagedObject>
            let migratedSlices = manager.destinationInstancesForEntityMappingNamed("SliceToSlice", sourceInstances: Array(sourceSlices))
            dInstance.setValue(Set(migratedSlices), forKey: "slices")
            dInstance.setValue(currencyUpdate!, forKey: "currencyUpdate")
            manager.associateSourceInstance(sInstance, withDestinationInstance: dInstance, forEntityMapping: mapping)
        }
    }
    
}