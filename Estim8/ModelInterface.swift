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
    
    func liveAccounts() -> [Account] //ordered
    
    func deadAccounts() -> [Account] //ordered
    
    func accountIsNegative(a: Account) -> Bool
    
    func accountOpenDate(a: Account) -> NSDate
    
    func accountClosingDate(a: Account) -> NSDate?
    
    func nameOfAccount(a: Account) -> String
    
    func accountOfUpdate(u: Update) -> Account
    
    func valueOfUpdate(u: Update) -> Float
    
    func dateOfUpdate(u: Update) -> NSDate
    
    func lastUpdatesOfSlice(s: Slice) -> [Update]
    
    func updatesOfAccount(a: Account) -> [Update] //ordered backwards, non-empty
    
    func slices() -> [Slice] //ordered backwards
    
    func dateOfSlice(s: Slice) -> NSDate
    
    func addAccountAnUpdate(name: String, value: Float, isNegative: Bool) -> Account
    
    func createSlice() -> Slice
    
    func updateAccount(a: Account, value: Float)
    
    func removeAccount(a: Account)
    
    func removeSlice(s: Slice)
    
}