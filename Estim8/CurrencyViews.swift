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
    
    func currency(_ n: Int) -> ControllerROCurrencyInterface?
    
    func marked(_ n: Int) -> Bool
    
    func select(_ n: Int) -> Bool
    
    func canSelect(_ n: Int) -> Bool
    
}

protocol ControllerListCurrenciesInterface {
    
    func numberOfCurrencies() -> Int
    
    func currency(_ n: Int) -> ControllerCurrencyInterface?
    
    func marked(_ n: Int) -> Bool
    
    func select(_ n: Int) -> Bool
    
    func canSelect(_ n: Int) -> Bool
    
    func createCurrency(handler: @escaping () -> ()) -> ControllerCreateCurrencyInterface
    
    func refreshData()
    
}

protocol ControllerCurrencySelectedProtocol {
    
    func currencySelected(_ currency: ControllerROCurrencyInterface)
    
}

protocol ControllerBaseCurrencySelectedProtocol {
    
    func currencySelected(_ currency: ControllerROCurrencyInterface?)
    
}

protocol ControllerEditCurrencyInterface: ControllerROCurrencyInterface {
    
    func setCurrency(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func canSetCurrency(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func remove() -> Bool
    
    func canRemove() -> Bool
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface?) -> ()) -> ControllerSelectCurrencyInterface
    
}

protocol ControllerCreateCurrencyInterface {
    
    func create(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func canCreate(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface?) -> ()) -> ControllerSelectCurrencyInterface
    
    func relative() -> ControllerROCurrencyInterface?
    
}
