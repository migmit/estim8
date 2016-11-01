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

protocol ControllerInterface {
    
    func numberOfAccounts() -> Int
    
    func account(_ n: Int, handler: @escaping (AccountResponse) -> ()) -> ControllerAccountInterface?
    
    func createAccount(handler: @escaping (()) -> ()) -> ControllerCreateAccountInterface
    
    func decant(handler: @escaping ((Int, Int)) -> ()) -> ControllerDecantInterface
    
    func showSlices() -> ControllerSlicesInterface
}

enum EditAccountCommand {
    case SetValue(NSDecimalNumber)
    case Remove
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface {
    
    func act(_ cmd: EditAccountCommand) -> Bool
    
    func canSetValue(_ value: NSDecimalNumber) -> Bool
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface) -> ()) -> ControllerListCurrenciesInterface
    
    func recalculate(_ value: NSDecimalNumber) -> NSDecimalNumber // from previously selected currency to the new one
    
}

struct CreateAccountCommand {
    let title: String
    let initialValue: NSDecimalNumber
    let isNegative: Bool
}

protocol ControllerCreateAccountInterface {
    
    func act(_ cmd: CreateAccountCommand) -> Bool
    
    func canCreate(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface) -> ()) -> ControllerListCurrenciesInterface
    
    func currency() -> ControllerROCurrencyInterface?
    
}

struct DecantCommand {
    let from: Int
    let to: Int
    let amount: NSDecimalNumber
    let useFromCurrency: Bool
}

protocol ControllerDecantInterface {
    
    func act(_ cmd: DecantCommand) -> Bool
    
    func numberOfAccounts() -> Int
    
    func account(_ n: Int) -> ControllerROAccountInterface?
    
    func canDecant(_ from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool
    
}

protocol ControllerSlicesInterface {
    
    func act(_ cmd: ()) -> Bool
    
    func numberOfSlices() -> Int
    
    func slice(_ n: Int) -> ControllerSliceInterface?
    
}
