//
//  CurrencyViewsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerSelectCurrencyImplementation<Model: ModelInterface>: Controller<ControllerROCurrencyInterface?>, ControllerSelectCurrencyInterface {
    
    let model: Model
    
    let baseFor: Model.Currency?
    
    let selected: Model.Currency?
    
    init(model: Model, baseFor: Model.Currency?, selected: Model.Currency?) {
        self.model = model
        self.baseFor = baseFor
        self.selected = selected
    }
    
    func numberOfCurrencies() -> Int {
        return model.liveCurrencies().count + 1
    }
    
    func currency(_ n: Int) -> ControllerROCurrencyInterface? {
        let currencies = model.liveCurrencies()
        if (n == 0 || n > currencies.count) {
            return nil
        } else {
            return ControllerROCurrencyImplementation<Model>(model: model, currency: currencies[n-1])
        }
    }
    
    func marked(_ n: Int) -> Bool {
        let currencies = model.liveCurrencies()
        if (n == 0) {
            return selected == nil
        } else if (n > currencies.count) {
            return false
        } else {
            return selected == currencies[n-1]
        }
    }
    
    func select(_ n: Int) -> Bool {
        if (canSelect(n)) {
            respond(currency(n))
            return true
        } else {
            return false
        }
    }
    
    func canSelect(_ n: Int) -> Bool {
        let currencies = model.liveCurrencies()
        if (n == 0) {
            return true
        } else if (n > currencies.count) {
            return false
        } else {
            if let bf = baseFor {
                var r = true
                var c: Model.Currency? = currencies[n-1]
                while (c != nil) {
                    if (c == bf) {
                        r = false
                        break
                    }
                    let lastUpdate = model.updatesOfCurrency(c!)[0]
                    c = model.currenciesOfUpdate(lastUpdate).1
                }
                return r
            } else {
                return true
            }
        }
    }
    
}

class ControllerListCurrenciesImplementation<Model: ModelInterface>: Controller<ControllerROCurrencyInterface>, ControllerListCurrenciesInterface {
    
    let model: Model
    
    let selected: Model.Currency?
    
    var currencies: [Model.Currency] = []
    
    var currencyData: [Model.Currency : ([(Model.Currency, Int)], [Model.Account])] = [:]//based on
    
    init(model: Model, selected: Model.Currency?) {
        self.model = model
        self.selected = selected
        super.init()
        refreshData()
    }
    
    func numberOfCurrencies() -> Int {
        return currencyData.count
    }
    
    func currency(_ n: Int) -> ControllerCurrencyInterface? {
        if (n >= currencies.count) {
            return nil
        } else {
            let c = currencies[n]
            if let data = currencyData[c] {
                return ControllerCurrencyImplementation(parent: self, model: model, currency: c, index: n, dependentCurrencies: data.0, accounts: data.1)
            } else {
                return nil
            }
        }
    }
    
    func marked(_ n: Int) -> Bool {
        if (n >= currencies.count) {
            return false
        } else {
            return selected == currencies[n]
        }
    }
    
    func select(_ n: Int) -> Bool {
        if (canSelect(n)) {
            if let c = currency(n) {
                respond(c)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func canSelect(_ n: Int) -> Bool {
        return true
    }
    
    func createCurrency1(handler: @escaping () -> ()) -> ControllerCreateCurrencyInterface {
        let createController = ControllerCreateCurrencyImplementation(model: model)
        createController.setResponseFunction{(_: ()) in
            self.refreshData()
            handler()
        }
        return createController
    }
    
    func refreshData() {
        currencies = model.liveCurrencies()
        let accounts = model.liveAccounts()
        currencyData = [:]
        if (currencies.count > 0) {
            for n in 0...(currencies.count - 1) {
                currencyData[currencies[n]] = ([], [])
            }
        }
        if (currencies.count > 0) {
            for n in 0...(currencies.count - 1) {
                let c = currencies[n]
                if
                    let d = model.currenciesOfUpdate(model.updatesOfCurrency(c)[0]).1,
                    let oldData = currencyData[d]
                {
                    currencyData[d] = (oldData.0 + [(c, n)], oldData.1)
                }
            }
        }
        if (accounts.count > 0) {
            for n in 0...(accounts.count - 1) {
                let a = accounts[n]
                let c = model.currencyOfUpdate(model.updatesOfAccount(a)[0])
                if let oldData = currencyData[c] {
                    currencyData[c] = (oldData.0, oldData.1 + [a])
                }
            }
        }
    }
    
}

enum EditCurrencyResponse {
    case Refresh(currencies:[Int])
    case Delete
}

class ControllerEditCurrencyImplementation<Model: ModelInterface>: Controller<EditCurrencyResponse>, ControllerEditCurrencyInterface {
    
    let model: Model
    
    let currency: Model.Currency
    
    let index: Int
    
    var baseCurrency: Model.Currency?
    
    let dependentCurrencies: [(Model.Currency, Int)]
    
    let accounts: [Model.Account]
    
    init(model: Model, currency: Model.Currency, index: Int, dependentCurrencies: [(Model.Currency, Int)], accounts: [Model.Account]) {
        self.model = model
        self.currency = currency
        self.index = index
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        self.baseCurrency = model.currenciesOfUpdate(lastUpdate).1
        self.dependentCurrencies = dependentCurrencies
        self.accounts = accounts
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
        return baseCurrency.map{ControllerROCurrencyImplementation(model: model, currency: $0)}
    }
    
    func onBase() -> (ControllerROCurrencyInterface, (NSDecimalNumber, NSDecimalNumber))? {
        return model.preferredBaseOfCurrency(currency).map {(preferredBase: Model.Currency) in
            (ControllerROCurrencyImplementation<Model>(model: model, currency: preferredBase), (model.exchangeRate(preferredBase, to: currency)))
        }
    }
    
    func setCurrency(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        if (canSetCurrency(name, code: code, symbol: symbol, rate: rate)) {
            model.changeCurrency(currency, name: name, code: code, symbol: symbol)
            model.updateCurrency(currency, base: baseCurrency, rate: rate.0, invRate: rate.1, manual: true)
            let currenciesToRefresh = (baseCurrency == nil) ? [] :
                dependentCurrencies.flatMap{c -> Int? in
                    let lastUpdate = model.updatesOfCurrency(c.0)[0]
                    if (model.currenciesOfUpdate(lastUpdate).1 == currency) { //SAFEGUARD
                        let dRate = model.rateOfCurrencyUpdate(lastUpdate)
                        let newRate = (rate.0.multiplying(by: dRate.0), rate.1.multiplying(by: dRate.1))
                        model.updateCurrency(c.0, base: baseCurrency, rate: newRate.0, invRate: newRate.1, manual: false)
                        return c.1
                    } else {
                        return nil
                    }
            }
            respond(.Refresh(currencies: currenciesToRefresh))
            return true
        } else {
            return false
        }
    }
    
    func canSetCurrency(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        return !name.isEmpty && rate.0.compare(0) == .orderedDescending && rate.1.compare(0) == .orderedDescending
    }
    
    func remove() -> Bool {
        if (canRemove()) {
            model.removeCurrency(currency)
            respond(.Delete)
            return true
        } else {
            return false
        }
    }
    
    func canRemove() -> Bool {
        return accounts.isEmpty
    }
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface?) -> ()) -> ControllerSelectCurrencyInterface {
        let selectCurrencyController = ControllerSelectCurrencyImplementation<Model>(model: model, baseFor: currency, selected: baseCurrency)
        selectCurrencyController.setResponseFunction{(currency: ControllerROCurrencyInterface?) in
            if let c = currency as? ControllerROCurrencyImplementation<Model> {
                self.baseCurrency = c.currency
            } else {
                self.baseCurrency = nil
            }
            handler(currency)
        }
        return selectCurrencyController
    }
    
}

class ControllerCreateCurrencyImplementation<Model: ModelInterface>: Controller<()>, ControllerCreateCurrencyInterface {
    
    let model: Model
    
    var baseCurrency: Model.Currency? = nil
    
    var rateMultiplier: (NSDecimalNumber, NSDecimalNumber) = (1,1)
    
    init(model: Model) {
        self.model = model
    }
    
    func create(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        if (canCreate(name, code: code, symbol: symbol, rate: rate)) {
            let newRate = (rate.0.multiplying(by: rateMultiplier.0), rate.1.multiplying(by: rateMultiplier.1))
            _ = model.addCurrencyAndUpdate(name, code: code, symbol: symbol, base: baseCurrency, rate: newRate.0, invRate: newRate.1, manual: true)
            respond(())
            return true
        } else {
            return false
        }
    }
    
    func canCreate(_ name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        return !name.isEmpty && rate.0.compare(0) == .orderedDescending && rate.1.compare(0) == .orderedDescending
    }
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface?) -> ()) -> ControllerSelectCurrencyInterface {
        let selectCurrencyController = ControllerSelectCurrencyImplementation<Model>(model: model, baseFor: nil, selected: nil)
        selectCurrencyController.setResponseFunction{(currency: ControllerROCurrencyInterface?) in
            if let c = currency as? ControllerROCurrencyImplementation<Model> {
                if let b = currency?.relative() as? ControllerROCurrencyImplementation<Model> {
                    self.baseCurrency = b.currency
                    self.rateMultiplier = c.rate()
                } else {
                    self.baseCurrency = c.currency
                    self.rateMultiplier = (1,1)
                }
            } else {
                self.baseCurrency = nil
            }
            handler(currency)
        }
        return selectCurrencyController
    }
    
    func relative() -> ControllerROCurrencyInterface? {
        if let b = baseCurrency {
            return ControllerROCurrencyImplementation(model: model, currency: b)
        } else {
            return nil
        }
    }
    
}
