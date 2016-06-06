//
//  CurrencyItemsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerROCurrencyImplementation<Model: ModelInterface>: ControllerROCurrencyInterface {
    
    let currency: Model.Currency
    
    let model: Model
    
    init(model: Model, currency: Model.Currency) {
        self.currency = currency
        self.model = model
    }
    
    func name() -> String {
        return model.nameOfCurrency(currency)
    }
    
    func code() -> String {
        return model.codeOfCurrency(currency)
    }
    
    func symbol() -> String {
        return model.symbolOfCurrency(currency)
    }
    
    func rate() -> (NSDecimalNumber, NSDecimalNumber) {
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        return model.rateOfCurrencyUpdate(lastUpdate)
    }
    
    func relative() -> ControllerROCurrencyInterface {
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        let rel = model.currenciesOfUpdate(lastUpdate).1
        return ControllerROCurrencyImplementation<Model>(model: model, currency: rel)
    }
    
}

class ControllerROCurrenciesImplementation<Model: ModelInterface>: ControllerROCurrenciesInterface { // SUBJECT TO REMOVAL!
    
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    func numberOfCurrencies() -> Int {
        return model.liveCurrencies().count
    }
    
    func currency(n: Int) -> ControllerROCurrencyInterface? {
        let currencies = model.liveCurrencies()
        if (n >= currencies.count) {
            return nil
        } else {
            return ControllerROCurrencyImplementation<Model>(model: model, currency: currencies[n])
        }
    }
    
}