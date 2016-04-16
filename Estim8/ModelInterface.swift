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
    
    func addAccountAndUpdate(name: String, value: NSDecimalNumber, isNegative: Bool) -> Account
    
    func createSlice() -> Slice
    
    func updateAccount(a: Account, value: NSDecimalNumber)
    
    func removeAccount(a: Account)
    
    func removeSlice(s: Slice)
    
}