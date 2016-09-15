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
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "removed == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            return results 
        } catch {
            return []
        }
    }
    
    func deadAccounts() -> [Account] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "removed == YES")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "closingDate", ascending: false)]
            [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            return results 
        } catch {
            return []
        }
    }
    
    func slices() -> [Slice] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Slice")
        fetchRequest.predicate = NSPredicate(format: "removed == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            return results 
        } catch {
            return []
        }
    }
    
    func accountIsNegative(_ a: Account) -> Bool {
        return a.value(forKey: "negative") as! Bool
    }
    
    func accountOpenDate(_ a: Account) -> Date {
        return a.value(forKey: "openDate") as! Date
    }
    
    func accountClosingDate(_ a: Account) -> Date? {
        return (a.value(forKey: "removed") as! Bool) ? a.value(forKey: "closingDate") as? Date : nil
    }
    
    func nameOfAccount(_ a: Account) -> String {
        return a.value(forKey: "title") as! String
    }
    
    func valueOfUpdate(_ u: Update) -> NSDecimalNumber {
        return u.value(forKey: "value") as! NSDecimalNumber
    }
    
    func dateOfUpdate(_ u: Update) -> Date {
        return u.value(forKey: "date") as! Date
    }
    
    func accountOfUpdate(_ u: Update) -> Account {
        return u.value(forKey: "account") as! Account
    }
    
    func lastUpdatesOfSlice(_ s: Slice) -> [Update] {
        return Array(s.value(forKey: "lastUpdates") as! Set<Update>)
    }
    
    func updatesOfAccount(_ a: Account) -> [Update] {
        return (a.value(forKey: "updates") as! Set<Update>).sorted{dateOfUpdate($0).compare(dateOfUpdate($1)) == .orderedDescending}
    }
    
    func dateOfSlice(_ s: Slice) -> Date {
        return s.value(forKey: "date") as! Date
    }
    
    func removeAccount(_ a: Account) {
        a.setValue(true, forKey: "removed")
        a.setValue(Date(), forKey: "closingDate")
        do {try managedObjectContext.save()} catch {}
    }
    
    func removeSlice(_ s: Slice) {
        s.setValue(true, forKey: "removed")
        do {try managedObjectContext.save()} catch {}
    }
    
    func updateAccount(_ a: Account, value: NSDecimalNumber, currency: Currency) {
        let updateDescr = NSEntityDescription.entity(forEntityName: "Update", in: managedObjectContext)!
        let update = NSManagedObject(entity: updateDescr, insertInto: managedObjectContext)
        update.setValue(Date(), forKey: "date")
        update.setValue(value, forKey: "value")
        update.setValue(a, forKey: "account")
        update.setValue(Set<Slice>(), forKey: "slices")
        let currencyUpdates = updatesOfCurrency(currency)
        update.setValue(currencyUpdates[0], forKey: "currencyUpdate")
        do {try managedObjectContext.save()} catch {}
    }
    
    func addAccountAndUpdate(_ title: String, value: NSDecimalNumber, isNegative: Bool, currency: Currency) -> Account? {
        let countRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Account")
        do {
            let count: Int = try managedObjectContext.count(for: countRequest)
        let accountDescr = NSEntityDescription.entity(forEntityName: "Account", in: managedObjectContext)!
        let account = NSManagedObject(entity: accountDescr, insertInto: managedObjectContext)
        account.setValue(isNegative, forKey: "negative")
        account.setValue(Date(), forKey: "openDate")
        account.setValue(false, forKey: "removed")
        account.setValue(title, forKey: "title")
        account.setValue(count, forKey: "sortingIndex")
        account.setValue(Set<Update>(), forKey: "updates")
        updateAccount(account, value: value, currency: currency)
        return account
        } catch {
            return nil
        }
    }
    
    func createSlice() -> Slice {
        let accounts = liveAccounts()
        let updates = accounts.map{updatesOfAccount($0)[0]}
        let sliceDescr = NSEntityDescription.entity(forEntityName: "Slice", in: managedObjectContext)!
        let slice = NSManagedObject(entity: sliceDescr, insertInto: managedObjectContext)
        slice.setValue(Date(), forKey: "date")
        slice.setValue(false, forKey: "removed")
        slice.setValue(Set<Update>(updates), forKey: "lastUpdates")
        do {try managedObjectContext.save()} catch {}
        return slice
    }
    
    //==================================
    
    func currencyOfUpdate(_ update: Update) -> Currency {
        return (update.value(forKey: "currencyUpdate") as! CurrencyUpdate).value(forKey: "currency") as! Currency
    }
    
    func codeOfCurrency(_ currency: Currency) -> String? {
        return currency.value(forKey: "code") as? String
    }
    
    func nameOfCurrency(_ currency: Currency) -> String {
        return currency.value(forKey: "name") as! String
    }
    
    func symbolOfCurrency(_ currency: Currency) -> String {
        return currency.value(forKey: "symbol") as! String
    }
    
    func currencyAddDate(_ currency: Currency) -> Date {
        return currency.value(forKey: "addDate") as! Date
    }
    
    func currencyRemoveDate(_ currency: Currency) -> Date? {
        return (currency.value(forKey: "removed") as! Bool) ? currency.value(forKey: "removeDate") as? Date : nil
    }
    
    func updatesOfCurrency(_ currency: Currency) -> [CurrencyUpdate] {
        return (currency.value(forKey: "updates") as! Set<CurrencyUpdate>).sorted{dateOfCurrencyUpdate($0).compare(dateOfCurrencyUpdate($1)) == .orderedDescending}
    }
    
    func currencyUpdateIsManual(_ cUpdate: CurrencyUpdate) -> Bool {
        return cUpdate.value(forKey: "manual") as! Bool
    }
    
    func dateOfCurrencyUpdate(_ cUpdate: CurrencyUpdate) -> Date {
        return cUpdate.value(forKey: "date") as! Date
    }
    
    func rateOfCurrencyUpdate(_ cUpdate: CurrencyUpdate) -> (NSDecimalNumber, NSDecimalNumber) {
        return (cUpdate.value(forKey: "rate") as! NSDecimalNumber, cUpdate.value(forKey: "inverseRate") as! NSDecimalNumber)
    }
    
    func currenciesOfUpdate(_ cUpdate: CurrencyUpdate) -> (Currency, Currency?) {
        return (cUpdate.value(forKey: "currency") as! Currency, cUpdate.value(forKey: "base") as? Currency)
    }
    
    func updateCurrency(_ currency: Currency, base: Currency?, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool) {
        let cUpdateDescr = NSEntityDescription.entity(forEntityName: "CurrencyUpdate", in: managedObjectContext)!
        let cUpdate = NSManagedObject(entity: cUpdateDescr, insertInto: managedObjectContext)
        cUpdate.setValue(Date(), forKey: "date")
        cUpdate.setValue(rate, forKey: "rate")
        cUpdate.setValue(invRate, forKey: "inverseRate")
        cUpdate.setValue(manual, forKey: "manual")
        cUpdate.setValue(base, forKey: "base")
        cUpdate.setValue(currency, forKey: "currency")
        cUpdate.setValue(Set<Update>(), forKey: "updates")
        do {try managedObjectContext.save()} catch {}
    }
    
    func changeCurrency(_ currency: Currency, name: String, code: String?, symbol: String) {
        currency.setValue(name, forKey: "name")
        currency.setValue(code, forKey: "code")
        currency.setValue(symbol, forKey: "symbol")
        do {try managedObjectContext.save()} catch {}    
    }
    
    func addCurrencyAndUpdate(_ name: String, code: String?, symbol: String, base: Currency?, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool) -> Currency? {
        let countRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Currency")
        do {
        let count: Int = try managedObjectContext.count(for: countRequest)
        let currencyDescr = NSEntityDescription.entity(forEntityName: "Currency", in: managedObjectContext)!
        let currency = NSManagedObject(entity: currencyDescr, insertInto: managedObjectContext)
        currency.setValue(name, forKey: "name")
        currency.setValue(code, forKey: "code")
        currency.setValue(symbol, forKey: "symbol")
        currency.setValue(Date(), forKey: "addDate")
        currency.setValue(false, forKey: "removed")
        currency.setValue(count, forKey: "sortingIndex")
        currency.setValue(Set<CurrencyUpdate>(), forKey: "based")
        currency.setValue(Set<CurrencyUpdate>(), forKey: "updates")
        updateCurrency(currency, base: base, rate: rate, invRate: invRate, manual: manual)
        return currency
        } catch {
            return nil
        }
    }
    
    func removeCurrency(_ currency: Currency) {
        currency.setValue(true, forKey: "removed")
        currency.setValue(Date(), forKey: "removeDate")
        do {try managedObjectContext.save()} catch {}
    }
    
    func liveCurrencies() -> [Currency] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Currency")
        fetchRequest.predicate = NSPredicate(format: "removed == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortingIndex", ascending: true)]
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            return results 
        } catch {
            return []
        }
    }
    
    func preferredBaseOfCurrency(_ currency: Currency) -> Currency? {
        return currency.value(forKey: "preferredBase") as? Currency
    }
    
}
