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
    
    func account(n: Int) -> ControllerAccountInterface?
    
    func createAccount()
    
    func decant()
    
    func showSlices()
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface, ControllerCurrencySelectedProtocol {
    
    func setValue(value: NSDecimalNumber) -> Bool
    
    func canSetValue(value: NSDecimalNumber) -> Bool
    
    func remove()
    
    func selectCurrency()
    
}

protocol ControllerCreateAccountInterface: ControllerCurrencySelectedProtocol {
    
    func create(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func canCreate(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func selectCurrency()
    
    func currency() -> ControllerROCurrencyInterface?
    
}

protocol ControllerDecantInterface {
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerROAccountInterface?
    
    func decant(from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool
    
    func canDecant(from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool
    
}

protocol ControllerSlicesInterface {
    
    func numberOfSlices() -> Int
    
    func slice(n: Int) -> ControllerSliceInterface?
    
}