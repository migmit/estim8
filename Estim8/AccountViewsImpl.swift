//
//  AccountViewsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerImplementation<Model: ModelInterface>: ControllerInterface {
    
    let model: Model
    
    weak var view: MainWindowView?
    
    init(model: Model) {
        self.model = model
    }
    
    func setView(view: MainWindowView) {
        self.view = view
    }
    
    func numberOfAccounts() -> Int {
        return model.liveAccounts().count
    }
    
    func account(n: Int) -> ControllerAccountInterface? {
        let accounts = model.liveAccounts()
        if (n >= accounts.count) {
            return nil
        } else {
            return ControllerAccountImplementation(parent: self, model: model, view: view!, account: accounts[n], index: n)
        }
    }
    
    func refreshAccount(n: Int) {
        view?.refreshAccount(n)
    }
    
    func removeAccount(n: Int) {
        view?.removeAccount(n)
    }
    
    func addAccount() {
        view?.addAccount()
    }
    
    func createAccount() {
        let createController = ControllerCreateAccountImplementation(parent: self, model: model)
        let createView = view!.createAccount(createController)
        createController.setView(createView)
        createView.showSubView()
    }
    
    func decant() {
        let decantController = ControllerDecantImplementation(parent: self, model: model)
        let decantView = view!.decant(decantController)
        decantController.setView(decantView)
        decantView.showSubView()
    }
    
    func showSlices() {
        let slicesController = ControllerSlicesImplementation(model: model)
        let slicesView = view!.showSlices(slicesController)
        slicesController.setView(slicesView)
        slicesView.showSubView()
    }
    
}

class ControllerEditAccountImplementation<Model: ModelInterface>: ControllerEditAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    weak var view: EditAccountView? = nil
    
    let account: Model.Account
    
    let index: Int
    
    var selectedCurrency: Model.Currency
    
    init(parent: ControllerImplementation<Model>, model: Model, account: Model.Account, index: Int) {
        self.parent = parent
        self.model = model
        self.account = account
        self.index = index
        let lastUpdate = model.updatesOfAccount(account)[0]
        selectedCurrency = model.currencyOfUpdate(lastUpdate)
    }
    
    func setView(view: EditAccountView) {
        self.view = view
    }
    
    func name() -> String {
        return model.nameOfAccount(account)
    }
    
    func value() -> NSDecimalNumber {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
    
    func isNegative() -> Bool {
        return model.accountIsNegative(account)
    }
    
    func currency() -> ControllerROCurrencyInterface {
        return ControllerROCurrencyImplementation<Model>(model: model, currency: selectedCurrency)
    }
    
    func setValue(value: NSDecimalNumber) -> Bool {
        if (canSetValue(value)) {
            view?.hideSubView()
            model.updateAccount(account, value: value, currency: selectedCurrency)
            parent.refreshAccount(index)
            return true
        } else {
            return false
        }
    }
    
    func canSetValue(value: NSDecimalNumber) -> Bool {
        let isNegative = model.accountIsNegative(account)
        let verifyValue = isNegative ? value.decimalNumberByMultiplyingBy(-1) : value
        return verifyValue.compare(0) != .OrderedAscending
    }
    
    func remove() {
        view?.hideSubView()
        model.removeAccount(account)
        parent.removeAccount(index)
    }
    
    func selectCurrency() {
        let listCurrenciesController = ControllerListCurrenciesImplementation<Model>(parent: self, model: model, selected: selectedCurrency)
        let listCurrenciesView = view!.selectCurrency(listCurrenciesController)
        listCurrenciesController.setView(listCurrenciesView)
        listCurrenciesView.showSubView()
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface) {
        if let c = currency as? ControllerROCurrencyImplementation<Model> {
            selectedCurrency = c.currency
        }
        view?.currencySelected(currency)
    }
    
}

class ControllerCreateAccountImplementation<Model: ModelInterface>: ControllerCreateAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    weak var view: CreateAccountView? = nil
    
    var selectedCurrency: Model.Currency? = nil
    
    init(parent: ControllerImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: CreateAccountView) {
        self.view = view
    }
    
    func create(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool {
        if (canCreate(title, initialValue: initialValue, isNegative: isNegative)) {
            if let c = selectedCurrency  {
                view?.hideSubView()
                model.addAccountAndUpdate(title, value: initialValue, isNegative: isNegative, currency: c)
                parent.addAccount()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func canCreate(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool {
        let verifyValue = isNegative ? initialValue.decimalNumberByMultiplyingBy(-1) : initialValue
        return verifyValue.compare(0) != .OrderedAscending && !title.isEmpty
    }
    
    func selectCurrency() {
        let listCurrenciesController = ControllerListCurrenciesImplementation<Model>(parent: self, model: model, selected: selectedCurrency)
        let listCurrenciesView = view!.selectCurrency(listCurrenciesController)
        listCurrenciesController.setView(listCurrenciesView)
        listCurrenciesView.showSubView()
    }
    
    func currencySelected(currency: ControllerROCurrencyInterface) {
        if let c = currency as? ControllerROCurrencyImplementation<Model> {
            selectedCurrency = c.currency
        }
        view?.currencySelected(currency)
    }
    
    func currency() -> ControllerROCurrencyInterface? {
        return selectedCurrency.map{ControllerROCurrencyImplementation<Model>(model: model, currency: $0)}
    }
    
}

class ControllerDecantImplementation<Model: ModelInterface>: ControllerDecantInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    weak var view: DecantView? = nil
    
    init(parent: ControllerImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: DecantView) {
        self.view = view
    }
    
    func numberOfAccounts() -> Int {
        return model.liveAccounts().count
    }
    
    func account(n: Int) -> ControllerROAccountInterface? {
        let accounts = model.liveAccounts()
        if (n >= accounts.count) {
            return nil
        } else {
            return ControllerROAccountImplementation(model: model, account: accounts[n])
        }
    }
    
    func decant(from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool {
        if let (amountFrom, amountTo) = decantData(from, to: to, amount: amount, useFromCurrency: useFromCurrency) {
            let accounts = model.liveAccounts()
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
            view?.hideSubView()
            let lastUpdateFrom = model.updatesOfAccount(accountFrom)[0]
            let lastUpdateTo = model.updatesOfAccount(accountTo)[0]
            model.updateAccount(accountFrom, value: amountFrom, currency: model.currencyOfUpdate(lastUpdateFrom))
            model.updateAccount(accountTo, value: amountTo, currency: model.currencyOfUpdate(lastUpdateTo))
            parent.refreshAccount(from)
            parent.refreshAccount(to)
            return true
        } else {
            return false
        }
    }
    
    func canDecant(from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool {
        return decantData(from, to: to, amount: amount, useFromCurrency: useFromCurrency) != nil
    }
    
    func decantData(from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> (NSDecimalNumber, NSDecimalNumber)? {
        let accounts = model.liveAccounts()
        if (from >= accounts.count || to >= accounts.count || from == to || amount == 0) {
            return nil
        } else {
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
            let currencyFrom = model.currencyOfUpdate(model.updatesOfAccount(accountFrom)[0])
            let currencyTo = model.currencyOfUpdate(model.updatesOfAccount(accountTo)[0])
            let rate = exchangeRate(currencyFrom, to: currencyTo)
            let addAmountFrom = useFromCurrency ? amount : amount.decimalNumberByMultiplyingBy(rate.0)
            let addAmountTo = useFromCurrency ? amount.decimalNumberByMultiplyingBy(rate.1) : amount
            if
                let amountFrom = tryAddToAccount(accountFrom, add: addAmountFrom.decimalNumberByMultiplyingBy(-1)),
                let amountTo = tryAddToAccount(accountTo, add: addAmountTo) {
                return (amountFrom, amountTo)
            } else {
                return nil
            }
        }
    }
    
    private func tryAddToAccount(account: Model.Account, add: NSDecimalNumber) -> NSDecimalNumber? {
        let isNegative = model.accountIsNegative(account)
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        let oldValue = model.valueOfUpdate(update)
        let newValue = oldValue.decimalNumberByAdding(add)
        let verifyValue = isNegative ? newValue.decimalNumberByMultiplyingBy(-1) : newValue
        if (verifyValue.compare(0) == .OrderedAscending) {
            return nil
        } else {
            return newValue
        }
    }
    
    private func exchangeRate(from: Model.Currency, to: Model.Currency) -> (NSDecimalNumber, NSDecimalNumber) { // from->to, to->from
        var fa = from
        let base = model.baseCurrency()
        var fRate: (NSDecimalNumber, NSDecimalNumber) = (1,1)
        var allFromAncestors = [(fa, fRate.0, fRate.1)]
        while (fa != base) {
            let lastUpdate = model.updatesOfCurrency(fa)[0]
            fa = model.currenciesOfUpdate(lastUpdate).1
            let rate = model.rateOfCurrencyUpdate(lastUpdate)
            fRate = (fRate.0.decimalNumberByMultiplyingBy(rate.0), fRate.1.decimalNumberByMultiplyingBy(rate.1))
            allFromAncestors.append((fa, fRate.0, fRate.1))
        }
        var tRate: (NSDecimalNumber, NSDecimalNumber) = (1,1)
        var ta = to
        while (!allFromAncestors.contains({triple in return triple.0 == ta})) {
            let lastUpdate = model.updatesOfCurrency(ta)[0]
            ta = model.currenciesOfUpdate(lastUpdate).1
            let rate = model.rateOfCurrencyUpdate(lastUpdate)
            tRate = (tRate.0.decimalNumberByMultiplyingBy(rate.0), tRate.1.decimalNumberByMultiplyingBy(rate.1))
        }
        return (tRate.0.decimalNumberByMultiplyingBy(fRate.1),tRate.1.decimalNumberByMultiplyingBy(fRate.0))
    }
    
}

class ControllerSlicesImplementation<Model: ModelInterface>: ControllerSlicesInterface {
    
    let model: Model
    
    weak var view: SlicesView? = nil
    
    let accounts: [Model.Account]
    
    init(model: Model) {
        self.model = model
        self.accounts = model.liveAccounts() + model.deadAccounts()
    }
    
    func setView(view: SlicesView) {
        self.view = view
    }
    
    func numberOfSlices() -> Int {
        return model.slices().count + 1
    }
    
    func slice(n: Int) -> ControllerSliceInterface? {
        let slices = model.slices()
        if (n == 0) {
            return ControllerCurrentStatePseudoSliceImplementation(parent: self, model: model)
        } else if (n > slices.count) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: self, model: model, slice: slices[n-1], index: n-1)
        }
    }
    
    func createSlice(slice: ControllerSliceInterface) {
        view?.createSlice(slice)
    }
    
    func removeSlice(slice: ControllerSliceInterface) {
        view?.removeSlice(slice)
    }
}