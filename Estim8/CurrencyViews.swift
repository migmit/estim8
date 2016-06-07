//
//  CurrencyViews.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerSelectCurrencyInterface {
    
    func numberOfCurrencies() -> Int
    
    func currency(n: Int) -> ControllerROCurrencyInterface?
    
    func select(n: Int) -> Bool
    
    func canSelect(n: Int) -> Bool
    
}

protocol ControllerListCurrenciesInterface {
    
    func numberOfCurrencies() -> Int
    
    func currency(n: Int) -> ControllerCurrencyInterface?
    
    func select(n: Int) -> Bool
    
    func canSelect(n: Int) -> Bool
    
}

protocol ControllerCurrencySelectedProtocol {
    
    func currencySelected(currency: ControllerROCurrencyInterface)
    
}

protocol ControllerEditCurrencyInterface: ControllerROCurrencyInterface, ControllerCurrencySelectedProtocol {
    
    func setCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool
    
    func canSetCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool
    
    func remove()
    
    func selectCurrency()
    
}

protocol ControllerCreateCurrencyInterface: ControllerCurrencySelectedProtocol {
    
    func create(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool
    
    func canCreate(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool
    
    func selectCurrency()
    
}