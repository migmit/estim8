//
//  Accounts.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerInterface {
    
    func numberOfAccounts() -> Int
    
    func account(_ n: Int) -> ControllerAccountInterface?
    
    func createAccount()
    
    func decant()
    
    func showSlices()
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface {
    
    func setValue(_ value: NSDecimalNumber) -> Bool
    
    func canSetValue(_ value: NSDecimalNumber) -> Bool
    
    func remove()
    
    func selectCurrency()
    
    func recalculate(_ value: NSDecimalNumber) -> NSDecimalNumber // from previously selected currency to the new one
    
}

protocol ControllerCreateAccountInterface {
    
    func create(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func canCreate(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func selectCurrency()
    
    func currency() -> ControllerROCurrencyInterface?
    
}

protocol ControllerDecantInterface {
    
    func numberOfAccounts() -> Int
    
    func account(_ n: Int) -> ControllerROAccountInterface?
    
    func decant(_ from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool
    
    func canDecant(_ from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool
    
}

protocol ControllerSlicesInterface {
    
    func numberOfSlices() -> Int
    
    func slice(_ n: Int) -> ControllerSliceInterface?
    
}
