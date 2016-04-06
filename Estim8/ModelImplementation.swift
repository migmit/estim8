//
//  ModelImplementation.swift
//  Estim8
//
//  Created by MigMit on 04/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation
import CoreData

class ModelImplementation: ModelInterface {
    
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    typealias Account = NSManagedObject
    
    typealias Slice = NSManagedObject
    
    typealias Update = NSManagedObject
    
    func liveAccounts() -> [Account] {
        let fetchRequest = NSFetchRequest(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "removed == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Account]
            return results ?? []
        } catch {
            return []
        }
    }
    
    func deadAccounts() -> [Account] {
        let fetchRequest = NSFetchRequest(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "removed == YES")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Account]
            return results ?? []
        } catch {
            return []
        }
    }
    
    func slices() -> [Slice] {
        let fetchRequest = NSFetchRequest(entityName: "Slice")
        fetchRequest.predicate = NSPredicate(format: "removed == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Slice]
            return results ?? []
        } catch {
            return []
        }
    }
    
    func accountIsNegative(a: Account) -> Bool {
        return a.valueForKey("negative") as! Bool
    }
    
    func accountOpenDate(a: Account) -> NSDate {
        return a.valueForKey("openDate") as! NSDate
    }
    
    func accountClosingDate(a: Account) -> NSDate? {
        return (a.valueForKey("removed") as! Bool) ? a.valueForKey("closingDate") as? NSDate : nil
    }
    
    func nameOfAccount(a: Account) -> String {
        return a.valueForKey("title") as! String
    }
    
    func valueOfUpdate(u: Update) -> Float {
        return u.valueForKey("value") as! Float
    }
    
    func dateOfUpdate(u: Update) -> NSDate {
        return u.valueForKey("date") as! NSDate
    }
    
    func accountOfUpdate(u: Update) -> Account {
        return u.valueForKey("account") as! Account
    }
    
    func lastUpdatesOfSlice(s: Slice) -> [Update] {
        return Array(s.valueForKey("lastUpdates") as! Set<Update>)
    }
    
    func updatesOfAccount(a: Account) -> [Update] {
        return (a.valueForKey("updates") as! Set<Update>).sort{dateOfUpdate($0).compare(dateOfUpdate($1)) == NSComparisonResult.OrderedDescending}
    }
    
    func dateOfSlice(s: Slice) -> NSDate {
        return s.valueForKey("date") as! NSDate
    }
    
    func removeAccount(a: Account) {
        a.setValue(true, forKey: "removed")
        a.setValue(NSDate(), forKey: "closingDate")
        do {try managedObjectContext.save()} catch {}
    }
    
    func removeSlice(s: Slice) {
        s.setValue(true, forKey: "removed")
        do {try managedObjectContext.save()} catch {}
    }
    
    func updateAccount(a: Account, value: Float) {
        let updateDescr = NSEntityDescription.entityForName("Update", inManagedObjectContext: managedObjectContext)!
        let update = NSManagedObject(entity: updateDescr, insertIntoManagedObjectContext: managedObjectContext)
        update.setValue(NSDate(), forKey: "date")
        update.setValue(value, forKey: "value")
        update.setValue(a, forKey: "account")
        update.setValue(Set<Slice>(), forKey: "slices")
        do {try managedObjectContext.save()} catch {}
    }
    
    func addAccountAnUpdate(title: String, value: Float, isNegative: Bool) -> Account {
        let countRequest = NSFetchRequest(entityName: "Account")
        var error: NSError?
        let count: Int = managedObjectContext.countForFetchRequest(countRequest, error: &error)
        let accountDescr = NSEntityDescription.entityForName("Account", inManagedObjectContext: managedObjectContext)!
        let account = NSManagedObject(entity: accountDescr, insertIntoManagedObjectContext: managedObjectContext)
        account.setValue(isNegative, forKey: "negative")
        account.setValue(NSDate(), forKey: "openDate")
        account.setValue(false, forKey: "removed")
        account.setValue(title, forKey: "title")
        account.setValue(count, forKey: "sortingIndex")
        account.setValue(Set<Update>(), forKey: "updates")
        updateAccount(account, value: value)
        return account
    }
    
    func createSlice() -> Slice {
        let accounts = liveAccounts()
        let updates = accounts.map{updatesOfAccount($0)[0]}
        let sliceDescr = NSEntityDescription.entityForName("Slice", inManagedObjectContext: managedObjectContext)!
        let slice = NSManagedObject(entity: sliceDescr, insertIntoManagedObjectContext: managedObjectContext)
        slice.setValue(NSDate(), forKey: "date")
        slice.setValue(false, forKey: "removed")
        slice.setValue(Set<Update>(updates), forKey: "lastUpdates")
        do {try managedObjectContext.save()} catch {}
        return slice
    }
    
}