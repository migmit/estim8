//
//  CurrencyItemsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerCurrencyHolderImplementation<Model: ModelInterface>: ControllerCurrencyHolderInterface {
    
    let currency: Model.Currency
    
    init(currency: Model.Currency) {
        self.currency = currency
    }
    
}

class ControllerROCurrencyImplementation<Model: ModelInterface>: ControllerCurrencyHolderImplementation<Model>, ControllerROCurrencyInterface {
    
    let model: Model
    
    init(model: Model, currency: Model.Currency) {
        self.model = model
        super.init(currency: currency)
    }
    
    func name() -> String {
        return model.nameOfCurrency(self.currency)
    }
    
    func symbol() -> String {
        return model.symbolOfCurrency(self.currency)
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