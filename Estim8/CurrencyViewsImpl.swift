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
    
    weak var view: SelectCurrencyView? = nil
    
    init(parent: ControllerCurrencySelectedProtocol, model: Model) {
        self.parent = parent
        self.model = model
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
    
    func select(n: Int) -> Bool {
        //TODO
        return false
    }
    
    func canSelect(n: Int) -> Bool {
        //TODO
        return false
    }
    
}

class ControllerListCurrenciesImplementation<Model: ModelInterface>: ControllerListCurrenciesInterface {
    
    let parent: ControllerCurrencySelectedProtocol
    
    let model: Model
    
    weak var view: ListCurrenciesView? = nil
    
    init(parent: ControllerCurrencySelectedProtocol, model: Model) {
        self.parent = parent
        self.model = model
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
            return ControllerCurrencyImplementation(model: model, currency: currencies[n])
        }
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

class ControllerEditCurrencyImplementation<Model: ModelInterface>: ControllerEditCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let model: Model
    
    weak var view: EditCurrencyView? = nil
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: EditCurrencyView) {
        self.view = view
    }
    
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

class ControllerCreateCurrencyImplementation<Model: ModelInterface>: ControllerCreateCurrencyInterface {
    
    let parent: ControllerListCurrenciesImplementation<Model>
    
    let model: Model
    
    weak var view: CreateCurrencyView? = nil
    
    init(parent: ControllerListCurrenciesImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: CreateCurrencyView) {
        self.view = view
    }
    
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