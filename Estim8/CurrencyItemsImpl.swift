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
    
    func code() -> String? {
        return model.codeOfCurrency(currency)
    }
    
    func symbol() -> String {
        return model.symbolOfCurrency(currency)
    }
    
    func rate() -> (NSDecimalNumber, NSDecimalNumber) {
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        return model.rateOfCurrencyUpdate(lastUpdate)
    }
    
    func relative() -> ControllerROCurrencyInterface? {
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        let rel = model.currenciesOfUpdate(lastUpdate).1
        return rel.map{ControllerROCurrencyImplementation<Model>(model: model, currency: $0)}
    }
    
    func onBase() -> (ControllerROCurrencyInterface, (NSDecimalNumber, NSDecimalNumber))? {
        return model.preferredBaseOfCurrency(currency).map {(preferredBase: Model.Currency) in
            (ControllerROCurrencyImplementation<Model>(model: model, currency: preferredBase), (model.exchangeRate(preferredBase, to: currency)))
        }
    }
    
}

class ControllerCurrencyImplementation<Model: ModelInterface>: ControllerROCurrencyImplementation<Model>, ControllerCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let index: Int
    
    let dependentCurrencies: [(Model.Currency, Int)]
    
    let accounts: [Model.Account]
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model, currency: Model.Currency, index: Int, dependentCurrencies: [(Model.Currency, Int)], accounts: [Model.Account]) {
        self.parent = parent
        self.index = index
        self.dependentCurrencies = dependentCurrencies
        self.accounts = accounts
        super.init(model: model, currency: currency)
    }
    
    func edit(handler: @escaping (EditCurrencyResponse) -> ()) -> ControllerEditCurrencyInterface {
        let editController = ControllerEditCurrencyImplementation<Model>(model: model, currency: currency, index: index, dependentCurrencies: dependentCurrencies, accounts: accounts)
        editController.setResponseFunction(handler)
        return editController
    }
    
    func remove() -> Bool {
        if (canRemove()) {
            model.removeCurrency(currency)
            return true
        } else {
            return false
        }
    }
    
    func canRemove() -> Bool {
        return accounts.isEmpty
    }
    
}
