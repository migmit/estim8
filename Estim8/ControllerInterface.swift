//
//  ControllerInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
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

protocol ControllerROAccountInterface {
    
    func name() -> String
    
    func value() -> NSDecimalNumber
    
    func isNegative() -> Bool
    
    func currency() -> ControllerROCurrencyInterface
    
}

protocol ControllerCurrencyHolderInterface {
    
}

protocol ControllerROCurrencyInterface: ControllerCurrencyHolderInterface {
    
    func name() -> String
    
    func symbol() -> String
    
}

protocol ControllerROCurrenciesInterface {
    
    func numberOfCurrencies() -> Int
    
    func currency(n: Int) -> ControllerROCurrencyInterface?
    
}

protocol ControllerAccountInterface: ControllerROAccountInterface {

    func edit()
    
    func remove()
    
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface {
    
    func setValue(value: NSDecimalNumber, currency: ControllerCurrencyHolderInterface) -> Bool
    
    func canSetValue(value: NSDecimalNumber, currency: ControllerCurrencyHolderInterface) -> Bool
    
    func remove()
    
}

protocol ControllerCreateAccountInterface {
    
    func create(title: String, initialValue: NSDecimalNumber, currency: ControllerCurrencyHolderInterface, isNegative: Bool) -> Bool
    
    func canCreate(title: String, initialValue: NSDecimalNumber, currency: ControllerCurrencyHolderInterface, isNegative: Bool) -> Bool
    
    func currencies() -> ControllerROCurrenciesInterface
    
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

protocol ControllerTransitionInterface {
    
}

protocol ControllerTransitionAccountInterface: ControllerROAccountInterface {
    
    func transition() -> ControllerTransitionInterface
    
}

protocol ControllerSliceInterface {
    
    func sliceIndex() -> Int
    
    func buttonCalledCreate() -> Bool
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerTransitionAccountInterface?
    
    func whereToMove(account: ControllerTransitionInterface) -> (Int, Bool)?
    
    func next() -> ControllerSliceInterface?
    
    func prev() -> ControllerSliceInterface?
    
    func createOrRemove()
    
    func sliceDate() -> NSDate?
}
