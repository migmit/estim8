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
    
    typealias Currency = NSManagedObject
    
    typealias CurrencyUpdate = NSManagedObject
    
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "closingDate", ascending: false)]
            [NSSortDescriptor(key: "sortingIndex", ascending: true)]
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
    
    func valueOfUpdate(u: Update) -> NSDecimalNumber {
        return u.valueForKey("value") as! NSDecimalNumber
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
        return (a.valueForKey("updates") as! Set<Update>).sort{dateOfUpdate($0).compare(dateOfUpdate($1)) == .OrderedDescending}
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
    
    func updateAccount(a: Account, value: NSDecimalNumber, currency: Currency) {
        let updateDescr = NSEntityDescription.entityForName("Update", inManagedObjectContext: managedObjectContext)!
        let update = NSManagedObject(entity: updateDescr, insertIntoManagedObjectContext: managedObjectContext)
        update.setValue(NSDate(), forKey: "date")
        update.setValue(value, forKey: "value")
        update.setValue(a, forKey: "account")
        update.setValue(Set<Slice>(), forKey: "slices")
        let currencyUpdates = updatesOfCurrency(currency)
        update.setValue(currencyUpdates[0], forKey: "currencyUpdate")
        do {try managedObjectContext.save()} catch {}
    }
    
    func addAccountAndUpdate(title: String, value: NSDecimalNumber, isNegative: Bool, currency: Currency) -> Account {
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
        updateAccount(account, value: value, currency: currency)
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
    
    //==================================
    
    func usdTempTempTemp() -> Currency {
        let fetchRequest = NSFetchRequest(entityName: "Currency")
        fetchRequest.predicate = NSPredicate(format: "code == 'USD'")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Currency]
            return results![0]
        } catch {
            return usdTempTempTemp()
        }
    }
    
    func currencyOfUpdate(update: Update) -> Currency {
        return (update.valueForKey("currencyUpdate") as! CurrencyUpdate).valueForKey("currency") as! Currency
    }
    
    func codeOfCurrency(currency: Currency) -> String {
        return currency.valueForKey("code") as! String
    }
    
    func nameOfCurrency(currency: Currency) -> String {
        return currency.valueForKey("name") as! String
    }
    
    func symbolOfCurrency(currency: Currency) -> String {
        return currency.valueForKey("symbol") as! String
    }
    
    func currencyAddDate(currency: Currency) -> NSDate {
        return currency.valueForKey("addDate") as! NSDate
    }
    
    func currencyRemoveDate(currency: Currency) -> NSDate? {
        return (currency.valueForKey("removed") as! Bool) ? currency.valueForKey("removeDate") as? NSDate : nil
    }
    
    func updatesOfCurrency(currency: Currency) -> [CurrencyUpdate] {
        return (currency.valueForKey("updates") as! Set<CurrencyUpdate>).sort{dateOfCurrencyUpdate($0).compare(dateOfCurrencyUpdate($1)) == .OrderedDescending}
    }
    
    func currencyUpdateIsManual(cUpdate: CurrencyUpdate) -> Bool {
        return cUpdate.valueForKey("manual") as! Bool
    }
    
    func dateOfCurrencyUpdate(cUpdate: CurrencyUpdate) -> NSDate {
        return cUpdate.valueForKey("date") as! NSDate
    }
    
    func rateOfCurrencyUpdate(cUpdate: CurrencyUpdate) -> (NSDecimalNumber, NSDecimalNumber) {
        return (cUpdate.valueForKey("rate") as! NSDecimalNumber, cUpdate.valueForKey("inverseRate") as! NSDecimalNumber)
    }
    
    func currenciesOfUpdate(cUpdate: CurrencyUpdate) -> (Currency, Currency) {
        return (cUpdate.valueForKey("currency") as! Currency, cUpdate.valueForKey("base") as! Currency)
    }
    
    func updateCurrency(currency: Currency, base: Currency, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool) {
        let cUpdateDescr = NSEntityDescription.entityForName("CurrencyUpdate", inManagedObjectContext: managedObjectContext)!
        let cUpdate = NSManagedObject(entity: cUpdateDescr, insertIntoManagedObjectContext: managedObjectContext)
        cUpdate.setValue(NSDate(), forKey: "date")
        cUpdate.setValue(rate, forKey: "rate")
        cUpdate.setValue(invRate, forKey: "inverseRate")
        cUpdate.setValue(manual, forKey: "manual")
        cUpdate.setValue(base, forKey: "base")
        cUpdate.setValue(currency, forKey: "currency")
        cUpdate.setValue(Set<Update>(), forKey: "updates")
        do {try managedObjectContext.save()} catch {}
    }
    
    func addCurrencyAndUpdate(name: String, code: String, symbol: String, base: Currency, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool) -> Currency {
        let countRequest = NSFetchRequest(entityName: "Currency")
        var error: NSError?
        let count: Int = managedObjectContext.countForFetchRequest(countRequest, error: &error)
        let currencyDescr = NSEntityDescription.entityForName("Currency", inManagedObjectContext: managedObjectContext)!
        let currency = NSManagedObject(entity: currencyDescr, insertIntoManagedObjectContext: managedObjectContext)
        currency.setValue(name, forKey: "name")
        currency.setValue(code, forKey: "code")
        currency.setValue(symbol, forKey: "symbol")
        currency.setValue(NSDate(), forKey: "addDate")
        currency.setValue(false, forKey: "removed")
        currency.setValue(count, forKey: "sortingIndex")
        currency.setValue(Set<CurrencyUpdate>(), forKey: "based")
        currency.setValue(Set<CurrencyUpdate>(), forKey: "updates")
        updateCurrency(currency, base: base, rate: rate, invRate: invRate, manual: manual)
        return currency
    }
    
    func removeCurrency(currency: Currency) {
        currency.setValue(true, forKey: "removed")
        currency.setValue(NSDate(), forKey: "removeDate")
        do {try managedObjectContext.save()} catch {}
    }
    
    func liveCurrencies() -> [Currency] {
        let fetchRequest = NSFetchRequest(entityName: "Currency")
        fetchRequest.predicate = NSPredicate(format: "removed == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Currency]
            return results ?? []
        } catch {
            return []
        }
    }
    
}