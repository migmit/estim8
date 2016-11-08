//
//  Accounts.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

enum AccountResponse {
    case Remove(index: Int)
    case Refresh(index: Int)
}

protocol ControllerAccountsInterface {
    
    func numberOfAccounts() -> Int
    
    func account(_ n: Int, handler: @escaping (AccountResponse) -> ()) -> ControllerAccountInterface?
    
    func createAccount(handler: @escaping (()) -> ()) -> ControllerCreateAccountInterface
    
    func decant(handler: @escaping ((Int, Int)) -> ()) -> ControllerDecantInterface
    
    func showSlices() -> ControllerSlicesInterface
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface {
    
    func setValue(_ value: NSDecimalNumber) -> Bool
    
    func canSetValue(_ value: NSDecimalNumber) -> Bool
    
    func remove()
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface) -> ()) -> ControllerListCurrenciesInterface
    
    func recalculate(_ value: NSDecimalNumber) -> NSDecimalNumber // from previously selected currency to the new one
    
}

protocol ControllerCreateAccountInterface {
    
    func create(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func canCreate(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface) -> ()) -> ControllerListCurrenciesInterface
    
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
