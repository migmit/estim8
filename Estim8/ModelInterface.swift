//
//  ModelInterface.swift
//  Estim8
//
//  Created by MigMit on 04/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ModelInterface {
    
    associatedtype Account: Hashable
    
    associatedtype Slice
    
    associatedtype Update
    
    associatedtype Currency: Hashable
    
    associatedtype CurrencyUpdate
    
    func liveAccounts() -> [Account] //ordered by index
    
    func deadAccounts() -> [Account] //ordered by date, descending
    
    func accountIsNegative(_ a: Account) -> Bool
    
    func accountOpenDate(_ a: Account) -> Date
    
    func accountClosingDate(_ a: Account) -> Date?
    
    func nameOfAccount(_ a: Account) -> String
    
    func accountOfUpdate(_ u: Update) -> Account
    
    func valueOfUpdate(_ u: Update) -> NSDecimalNumber
    
    func dateOfUpdate(_ u: Update) -> Date
    
    func lastUpdatesOfSlice(_ s: Slice) -> [Update]
    
    func updatesOfAccount(_ a: Account) -> [Update] //ordered backwards, non-empty
    
    func slices() -> [Slice] //ordered backwards
    
    func dateOfSlice(_ s: Slice) -> Date
    
    func addAccountAndUpdate(_ name: String, value: NSDecimalNumber, isNegative: Bool, currency: Currency) -> Account?
    
    func createSlice() -> Slice
    
    func updateAccount(_ a: Account, value: NSDecimalNumber, currency: Currency)
    
    func removeAccount(_ a: Account)
    
    func removeSlice(_ s: Slice)
    
    //==================================
    
    func currencyOfUpdate(_ update: Update) -> Currency
    
    func codeOfCurrency(_ currency: Currency) -> String? // "USD", "HUF"
    
    func nameOfCurrency(_ currency: Currency) -> String // "US dollar", "Hungarian forint"
    
    func symbolOfCurrency(_ currency: Currency) -> String // "$", "Ft"
    
    func currencyAddDate(_ currency: Currency) -> Date
    
    func currencyRemoveDate(_ currency: Currency) -> Date?
    
    func updatesOfCurrency(_ currency: Currency) -> [CurrencyUpdate] // ordered backwards, non-empty
    
    func currencyUpdateIsManual(_ cUpdate: CurrencyUpdate) -> Bool
    
    func dateOfCurrencyUpdate(_ cUpdate: CurrencyUpdate) -> Date
    
    func rateOfCurrencyUpdate(_ cUpdate: CurrencyUpdate) -> (NSDecimalNumber, NSDecimalNumber) // rate, inverse rate
    
    func currenciesOfUpdate(_ cUpdate: CurrencyUpdate) -> (Currency, Currency?) // currency, based on
    
    func updateCurrency(_ currency: Currency, base: Currency?, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool)
    
    func changeCurrency(_ currency: Currency, name: String, code: String?, symbol: String)
    
    func addCurrencyAndUpdate(_ name: String, code: String?, symbol: String, base: Currency?, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool) -> Currency?
    
    func removeCurrency(_ currency: Currency)
    
    func liveCurrencies() -> [Currency]
    
    func preferredBaseOfCurrency(_ currency: Currency) -> Currency?
    
}

extension ModelInterface {
    
    final func exchangeRate(_ from: Currency, to: Currency) -> (NSDecimalNumber, NSDecimalNumber) { // from->to, to->from
        var fa: Currency? = from
        var fRate: (NSDecimalNumber, NSDecimalNumber) = (1,1)
        var allFromAncestors = [(fa, fRate.0, fRate.1)]
        while (fa != nil) {
            let lastUpdate = updatesOfCurrency(fa!)[0]
            fa = currenciesOfUpdate(lastUpdate).1
            let rate = rateOfCurrencyUpdate(lastUpdate)
            fRate = (fRate.0.multiplying(by: rate.0), fRate.1.multiplying(by: rate.1))
            allFromAncestors.append((fa, fRate.0, fRate.1))
        }
        var tRate: (NSDecimalNumber, NSDecimalNumber) = (1,1)
        var ta: Currency? = to
        while (!allFromAncestors.contains(where: {triple in return triple.0 == ta})) {
            let lastUpdate = updatesOfCurrency(ta!)[0]
            ta = currenciesOfUpdate(lastUpdate).1
            let rate = rateOfCurrencyUpdate(lastUpdate)
            tRate = (tRate.0.multiplying(by: rate.0), tRate.1.multiplying(by: rate.1))
        }
        return (tRate.0.multiplying(by: fRate.1),tRate.1.multiplying(by: fRate.0))
    }
    
}
