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
    
    func accountIsNegative(a: Account) -> Bool
    
    func accountOpenDate(a: Account) -> NSDate
    
    func accountClosingDate(a: Account) -> NSDate?
    
    func nameOfAccount(a: Account) -> String
    
    func accountOfUpdate(u: Update) -> Account
    
    func valueOfUpdate(u: Update) -> NSDecimalNumber
    
    func dateOfUpdate(u: Update) -> NSDate
    
    func lastUpdatesOfSlice(s: Slice) -> [Update]
    
    func updatesOfAccount(a: Account) -> [Update] //ordered backwards, non-empty
    
    func slices() -> [Slice] //ordered backwards
    
    func dateOfSlice(s: Slice) -> NSDate
    
    func addAccountAndUpdate(name: String, value: NSDecimalNumber, isNegative: Bool, currency: Currency) -> Account
    
    func createSlice() -> Slice
    
    func updateAccount(a: Account, value: NSDecimalNumber, currency: Currency)
    
    func removeAccount(a: Account)
    
    func removeSlice(s: Slice)
    
    //==================================
    
    func currencyOfUpdate(update: Update) -> Currency
    
    func codeOfCurrency(currency: Currency) -> String? // "USD", "HUF"
    
    func nameOfCurrency(currency: Currency) -> String // "US dollar", "Hungarian forint"
    
    func symbolOfCurrency(currency: Currency) -> String // "$", "Ft"
    
    func currencyAddDate(currency: Currency) -> NSDate
    
    func currencyRemoveDate(currency: Currency) -> NSDate?
    
    func updatesOfCurrency(currency: Currency) -> [CurrencyUpdate] // ordered backwards, non-empty
    
    func currencyUpdateIsManual(cUpdate: CurrencyUpdate) -> Bool
    
    func dateOfCurrencyUpdate(cUpdate: CurrencyUpdate) -> NSDate
    
    func rateOfCurrencyUpdate(cUpdate: CurrencyUpdate) -> (NSDecimalNumber, NSDecimalNumber) // rate, inverse rate
    
    func currenciesOfUpdate(cUpdate: CurrencyUpdate) -> (Currency, Currency?) // currency, based on
    
    func updateCurrency(currency: Currency, base: Currency?, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool)
    
    func changeCurrency(currency: Currency, name: String, code: String?, symbol: String)
    
    func addCurrencyAndUpdate(name: String, code: String?, symbol: String, base: Currency?, rate: NSDecimalNumber, invRate: NSDecimalNumber, manual: Bool) -> Currency
    
    func removeCurrency(currency: Currency)
    
    func liveCurrencies() -> [Currency]
    
}