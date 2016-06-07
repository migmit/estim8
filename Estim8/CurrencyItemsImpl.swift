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

class ControllerCurrencyImplementation<Model: ModelInterface>: ControllerCurrencyInterface {
    
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

    func edit() {
        //TODO
    }
    
    func remove() {
        //TODO
    }
    
}