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
    
    func marked(n: Int) -> Bool
    
    func select(n: Int) -> Bool
    
    func canSelect(n: Int) -> Bool
    
}

protocol ControllerListCurrenciesInterface {
    
    func numberOfCurrencies() -> Int
    
    func currency(n: Int) -> ControllerCurrencyInterface?
    
    func marked(n: Int) -> Bool
    
    func select(n: Int) -> Bool
    
    func canSelect(n: Int) -> Bool
    
}

protocol ControllerCurrencySelectedProtocol {
    
    func currencySelected(currency: ControllerROCurrencyInterface)
    
}

protocol ControllerEditCurrencyInterface: ControllerROCurrencyInterface, ControllerCurrencySelectedProtocol {
    
    func setCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func canSetCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func remove() -> Bool
    
    func canRemove() -> Bool
    
    func selectCurrency()
    
}

protocol ControllerCreateCurrencyInterface: ControllerCurrencySelectedProtocol {
    
    func create(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func canCreate(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func selectCurrency()
    
    func relative() -> ControllerROCurrencyInterface?
    
}