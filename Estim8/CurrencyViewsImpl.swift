//
//  CurrencyViewsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerSelectCurrencyImplementation: ControllerSelectCurrencyInterface {
    
    func numberOfCurrencies() -> Int {
        //TODO
        return 0
    }
    
    func currency(n: Int) -> ControllerROCurrencyInterface? {
        //TODO
        return nil
    }
    
    func select(n: Int) -> Bool {
        //TODO
        return false
    }
    
    func canSelect(n: Int) -> Bool {
        //TODO
        return false
    }
    
}

class ControllerListCurrenciesImplementation: ControllerListCurrenciesInterface {
    
    func numberOfCurrencies() -> Int {
        //TODO
        return 0
    }
    
    func currency(n: Int) -> ControllerCurrencyInterface? {
        //TODO
        return nil
    }
    
    func select(n: Int) -> Bool {
        //TODO
        return false
    }
    
    func canSelect(n: Int) -> Bool {
        //TODO
        return false
    }
    
}

class ControllerEditCurrencyImplementation: ControllerEditCurrencyInterface {
    
    func name() -> String {
        //TODO
        return ""
    }
    
    func code() -> String {
        //TODO
        return ""
    }
    
    func symbol() -> String {
        //TODO
        return ""
    }
    
    func rate() -> (NSDecimalNumber, NSDecimalNumber) {
        //TODO
        return (0,0)
    }
    
    func relative() -> ControllerROCurrencyInterface {
        //TODO
        return relative()
    }
    
    func setCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool {
        //TODO
        return false
    }
    
    func canSetCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool {
        //TODO
        return false
    }
    
    func remove() {
        //TODO
    }
    
    func selectCurrency() {
        //TODO
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface) {
        //TODO
    }
    
}

class ControllerCreateCurrencyImplementation: ControllerCreateCurrencyInterface {
    
    func create(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool {
        //TODO
        return false
    }
    
    func canCreate(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber), relative: ControllerROCurrencyInterface) -> Bool {
        //TODO
        return false
    }
    
    func selectCurrency() {
        //TODO
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface) {
        //TODO
    }
    
}