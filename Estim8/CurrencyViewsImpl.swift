//
//  CurrencyViewsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerSelectCurrencyImplementation<Model: ModelInterface>: ControllerSelectCurrencyInterface {
    
    let parent: ControllerBaseCurrencySelectedProtocol
    
    let model: Model
    
    let baseFor: Model.Currency?
    
    let selected: Model.Currency?
    
    weak var view: SelectCurrencyView? = nil
    
    init(parent: ControllerBaseCurrencySelectedProtocol, model: Model, baseFor: Model.Currency?, selected: Model.Currency?) {
        self.parent = parent
        self.model = model
        self.baseFor = baseFor
        self.selected = selected
    }
    
    func setView(view: SelectCurrencyView) {
        self.view = view
    }
    
    func numberOfCurrencies() -> Int {
        return model.liveCurrencies().count + 1
    }
    
    func currency(n: Int) -> ControllerROCurrencyInterface? {
        let currencies = model.liveCurrencies()
        if (n == 0 || n > currencies.count) {
            return nil
        } else {
            return ControllerROCurrencyImplementation<Model>(model: model, currency: currencies[n-1])
        }
    }
    
    func marked(n: Int) -> Bool {
        let currencies = model.liveCurrencies()
        if (n == 0) {
            return selected == nil
        } else if (n > currencies.count) {
            return false
        } else {
            return selected == currencies[n-1]
        }
    }
    
    func select(n: Int) -> Bool {
        if (canSelect(n)) {
            view?.hideSubView()
            parent.currencySelected(currency(n))
            return true
        } else {
            return false
        }
    }
    
    func canSelect(n: Int) -> Bool {
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

class ControllerListCurrenciesImplementation<Model: ModelInterface>: ControllerListCurrenciesInterface {
    
    let parent: ControllerCurrencySelectedProtocol
    
    let model: Model
    
    let selected: Model.Currency?
    
    var currencies: [Model.Currency] = []
    
    var currencyData: [Model.Currency : ([(Model.Currency, Int)], [Model.Account])] = [:]//based on
    
    weak var view: ListCurrenciesView? = nil
    
    init(parent: ControllerCurrencySelectedProtocol, model: Model, selected: Model.Currency?) {
        self.parent = parent
        self.model = model
        self.selected = selected
        refreshData()
    }
    
    func setView(view: ListCurrenciesView) {
        self.view = view
    }
    
    func numberOfCurrencies() -> Int {
        return currencyData.count
    }
    
    func currency(n: Int) -> ControllerCurrencyInterface? {
        if (n >= currencies.count) {
            return nil
        } else {
            let c = currencies[n]
            if let data = currencyData[c] {
                return ControllerCurrencyImplementation(parent: self, model: model, view: view!, currency: c, index: n, dependentCurrencies: data.0, accounts: data.1)
            } else {
                return nil
            }
        }
    }
    
    func marked(n: Int) -> Bool {
        if (n >= currencies.count) {
            return false
        } else {
            return selected == currencies[n]
        }
    }
    
    func select(n: Int) -> Bool {
        if (canSelect(n)) {
            if let c = currency(n) {
                view?.hideSubView()
                parent.currencySelected(c)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func canSelect(n: Int) -> Bool {
        return true
    }
    
    func createCurrency() {
        let createController = ControllerCreateCurrencyImplementation(parent: self, model: model)
        let createView = view!.createCurrency(createController)
        createController.setView(createView)
        createView.showSubView()
    }
    
    func refreshCurrency(n: Int) {
        refreshData()
        view?.refreshCurrency(n)
    }
    
    func removeCurrency(n: Int) {
        refreshData()
        view?.removeCurrency(n)
    }
    
    func addCurrency() {
        refreshData()
        view?.addCurrency()
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

class ControllerEditCurrencyImplementation<Model: ModelInterface>: ControllerEditCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let model: Model
    
    let currency: Model.Currency
    
    let index: Int
    
    var baseCurrency: Model.Currency?
    
    let dependentCurrencies: [(Model.Currency, Int)]
    
    let accounts: [Model.Account]
    
    weak var view: EditCurrencyView? = nil
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model, currency: Model.Currency, index: Int, dependentCurrencies: [(Model.Currency, Int)], accounts: [Model.Account]) {
        self.parent = parent
        self.model = model
        self.currency = currency
        self.index = index
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        self.baseCurrency = model.currenciesOfUpdate(lastUpdate).1
        self.dependentCurrencies = dependentCurrencies
        self.accounts = accounts
    }
    
    func setView(view: EditCurrencyView) {
        self.view = view
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
    
    func setCurrency(name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        if (canSetCurrency(name, code: code, symbol: symbol, rate: rate)) {
            view?.hideSubView()
            model.changeCurrency(currency, name: name, code: code, symbol: symbol)
            model.updateCurrency(currency, base: baseCurrency, rate: rate.0, invRate: rate.1, manual: true)
            parent.refreshCurrency(index)
            if (baseCurrency != nil) {
                for c in dependentCurrencies {
                    let lastUpdate = model.updatesOfCurrency(c.0)[0]
                    if (model.currenciesOfUpdate(lastUpdate).1 == currency) { //SAFEGUARD
                        let dRate = model.rateOfCurrencyUpdate(lastUpdate)
                        let newRate = (rate.0.decimalNumberByMultiplyingBy(dRate.0), rate.1.decimalNumberByMultiplyingBy(dRate.1))
                        model.updateCurrency(c.0, base: baseCurrency, rate: newRate.0, invRate: newRate.1, manual: false)
                        parent.refreshCurrency(c.1)
                    }
                }
            }
            return true
        } else {
            return false
        }
    }
    
    func canSetCurrency(name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        return !name.isEmpty && rate.0.compare(0) == .OrderedDescending && rate.1.compare(0) == .OrderedDescending
    }
    
    func remove() -> Bool {
        if (canRemove()) {
            view?.hideSubView()
            model.removeCurrency(currency)
            parent.removeCurrency(index)
            return true
        } else {
            return false
        }
    }
    
    func canRemove() -> Bool {
        return accounts.isEmpty
    }
    
    func selectCurrency() {
        let selectCurrencyController = ControllerSelectCurrencyImplementation<Model>(parent: self, model: model, baseFor: currency, selected: baseCurrency)
        let selectCurrencyView = view!.selectRelative(selectCurrencyController)
        selectCurrencyController.setView(selectCurrencyView)
        selectCurrencyView.showSubView()
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface?) {
        if let c = currency as? ControllerROCurrencyImplementation<Model> {
            baseCurrency = c.currency
        } else {
            baseCurrency = nil
        }
        view?.relativeSelected(currency)
    }
    
}

class ControllerCreateCurrencyImplementation<Model: ModelInterface>: ControllerCreateCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let model: Model
    
    var baseCurrency: Model.Currency? = nil
    
    var rateMultiplier: (NSDecimalNumber, NSDecimalNumber) = (1,1)
    
    weak var view: CreateCurrencyView? = nil
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: CreateCurrencyView) {
        self.view = view
    }
    
    func create(name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        if (canCreate(name, code: code, symbol: symbol, rate: rate)) {
            view?.hideSubView()
            let newRate = (rate.0.decimalNumberByMultiplyingBy(rateMultiplier.0), rate.1.decimalNumberByMultiplyingBy(rateMultiplier.1))
            model.addCurrencyAndUpdate(name, code: code, symbol: symbol, base: baseCurrency, rate: newRate.0, invRate: newRate.1, manual: true)
            parent.addCurrency()
            return true
        } else {
            return false
        }
    }
    
    func canCreate(name: String, code: String?, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        return !name.isEmpty && rate.0.compare(0) == .OrderedDescending && rate.1.compare(0) == .OrderedDescending
    }
    
    func selectCurrency() {
        let selectCurrencyController = ControllerSelectCurrencyImplementation<Model>(parent: self, model: model, baseFor: nil, selected: nil)
        let selectCurrencyView = view!.selectRelative(selectCurrencyController)
        selectCurrencyController.setView(selectCurrencyView)
        selectCurrencyView.showSubView()
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface?) {
        if let c = currency as? ControllerROCurrencyImplementation<Model> {
            if let b = currency?.relative() as? ControllerROCurrencyImplementation<Model> {
                baseCurrency = b.currency
                rateMultiplier = c.rate()
            } else {
                baseCurrency = c.currency
                rateMultiplier = (1,1)
            }
        } else {
            baseCurrency = nil
        }
        view?.relativeSelected(currency)
    }
    
    func relative() -> ControllerROCurrencyInterface? {
        if let b = baseCurrency {
            return ControllerROCurrencyImplementation(model: model, currency: b)
        } else {
            return nil
        }
    }
    
}