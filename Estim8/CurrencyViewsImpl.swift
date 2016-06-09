//
//  CurrencyViewsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerSelectCurrencyImplementation<Model: ModelInterface>: ControllerSelectCurrencyInterface {
    
    let parent: ControllerCurrencySelectedProtocol
    
    let model: Model
    
    let baseFor: Model.Currency?
    
    weak var view: SelectCurrencyView? = nil
    
    init(parent: ControllerCurrencySelectedProtocol, model: Model, baseFor: Model.Currency?) {
        self.parent = parent
        self.model = model
        self.baseFor = baseFor
    }
    
    func setView(view: SelectCurrencyView) {
        self.view = view
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
    
    func marked(n: Int) -> Bool {
        let currencies = model.liveCurrencies()
        if (n >= currencies.count) {
            return false
        } else {
            return baseFor == currencies[n]
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
        let currencies = model.liveCurrencies()
        if (n >= currencies.count || baseFor == model.baseCurrency()) {
            return false
        } else {
            if let bf = baseFor {
                var r = true
                var c = currencies[n]
                while (c != model.baseCurrency()) {
                    if (c == bf) {
                        r = false
                    }
                    let lastUpdate = model.updatesOfCurrency(c)[0]
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
    
    weak var view: ListCurrenciesView? = nil
    
    init(parent: ControllerCurrencySelectedProtocol, model: Model, selected: Model.Currency?) {
        self.parent = parent
        self.model = model
        self.selected = selected
    }
    
    func setView(view: ListCurrenciesView) {
        self.view = view
    }
    
    func numberOfCurrencies() -> Int {
        return model.liveCurrencies().count
    }
    
    func currency(n: Int) -> ControllerCurrencyInterface? {
        let currencies = model.liveCurrencies()
        if (n >= currencies.count) {
            return nil
        } else {
            return ControllerCurrencyImplementation(parent: self, model: model, view: view!, currency: currencies[n], index: n)
        }
    }
    
    func marked(n: Int) -> Bool {
        let currencies = model.liveCurrencies()
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
    
    func refreshCurrency(n: Int) {
        view?.refreshCurrency(n)
    }
    
    func removeCurrency(n: Int) {
        view?.removeCurrency(n)
    }
    
    func addCurrency() {
        view?.addCurrency()
    }
    
}

class ControllerEditCurrencyImplementation<Model: ModelInterface>: ControllerEditCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let model: Model
    
    let currency: Model.Currency
    
    let index: Int
    
    var baseCurrency: ControllerROCurrencyInterface
    
    weak var view: EditCurrencyView? = nil
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model, currency: Model.Currency, index: Int) {
        self.parent = parent
        self.model = model
        self.currency = currency
        self.index = index
        let lastUpdate = model.updatesOfCurrency(currency)[0]
        self.baseCurrency = ControllerROCurrencyImplementation(model: model, currency: model.currenciesOfUpdate(lastUpdate).1)
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
    
    func relative() -> ControllerROCurrencyInterface {
        return baseCurrency
    }
    
    func setCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        if (canSetCurrency(name, code: code, symbol: symbol, rate: rate)) {
            if let r = baseCurrency as? ControllerROCurrencyImplementation<Model> {
                view?.hideSubView()
                model.updateCurrency(currency, base: r.currency, rate: rate.0, invRate: rate.1, manual: true)
                parent.refreshCurrency(index)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func canSetCurrency(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
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
        return model.currenciesBasedOn(currency).isEmpty
    }
    
    func selectCurrency() {
        let selectCurrencyController = ControllerSelectCurrencyImplementation<Model>(parent: self, model: model, baseFor: currency)
        let selectCurrencyView = view!.selectRelative(selectCurrencyController)
        selectCurrencyController.setView(selectCurrencyView)
        selectCurrencyView.showSubView()
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface) {
        baseCurrency = currency
        view?.relativeSelected(currency)
    }
    
}

class ControllerCreateCurrencyImplementation<Model: ModelInterface>: ControllerCreateCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let model: Model
    
    var baseCurrency: ControllerROCurrencyInterface? = nil
    
    weak var view: CreateCurrencyView? = nil
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: CreateCurrencyView) {
        self.view = view
    }
    
    func create(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        if (canCreate(name, code: code, symbol: symbol, rate: rate)) {
            if let b = baseCurrency as? ControllerROCurrencyImplementation<Model> {
                view?.hideSubView()
                model.addCurrencyAndUpdate(name, code: code, symbol: symbol, base: b.currency, rate: rate.0, invRate: rate.1, manual: true)
                parent.addCurrency()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func canCreate(name: String, code: String, symbol: String, rate: (NSDecimalNumber, NSDecimalNumber)) -> Bool {
        return !name.isEmpty && baseCurrency != nil && rate.0.compare(0) == .OrderedDescending && rate.1.compare(0) == .OrderedDescending
    }
    
    func selectCurrency() {
        let selectCurrencyController = ControllerSelectCurrencyImplementation<Model>(parent: self, model: model, baseFor: nil)
        let selectCurrencyView = view!.selectRelative(selectCurrencyController)
        selectCurrencyController.setView(selectCurrencyView)
        selectCurrencyView.showSubView()
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface) {
        baseCurrency = currency
        view?.relativeSelected(currency)
    }
    
}