//
//  AccountViewsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerAccountsImplementation<Model: ModelInterface>: ControllerAccountsInterface {
    
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    func numberOfAccounts() -> Int {
        return model.liveAccounts().count
    }
    
    func account(_ n: Int, handler: @escaping (AccountResponse) -> ()) -> ControllerAccountInterface? {
        let accounts = model.liveAccounts()
        if (n >= accounts.count) {
            return nil
        } else {
            return ControllerAccountImplementation(model: model, account: accounts[n]){(response: EditResponse) in
                switch response {
                case .Delete:
                    handler(.Remove(index: n))
                case .SetValue:
                    handler(.Refresh(index: n))
                }
            }
        }
    }
    
    func createAccount(handler: @escaping (()) -> ()) -> ControllerCreateAccountInterface {
        return ControllerCreateAccountImplementation(model: model).setResponseFunction(handler)
    }
    
    func decant(handler: @escaping ((Int, Int)) -> ()) -> ControllerDecantInterface {
        return ControllerDecantImplementation(model: model).setResponseFunction(handler)
    }
    
}

enum EditResponse {
    case SetValue
    case Delete
}

class ControllerEditAccountImplementation<Model: ModelInterface>: Controller<EditResponse>, ControllerEditAccountInterface {
    
    let model: Model
    
    let account: Model.Account
    
    var oldCurrency: Model.Currency
    
    var selectedCurrency: Model.Currency
    
    init(model: Model, account: Model.Account) {
        self.model = model
        self.account = account
        let lastUpdate = model.updatesOfAccount(account)[0]
        selectedCurrency = model.currencyOfUpdate(lastUpdate)
        oldCurrency = selectedCurrency
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
    
    func setValue(_ value: NSDecimalNumber) -> Bool {
        if (canSetValue(value)) {
            model.updateAccount(account, value: value, currency: selectedCurrency)
            respond(.SetValue)
            return true
        } else {
            return false
        }
    }
    
    func canSetValue(_ value: NSDecimalNumber) -> Bool {
        let isNegative = model.accountIsNegative(account)
        let verifyValue = isNegative ? value.multiplying(by: -1) : value
        return verifyValue.compare(0) != .orderedAscending
    }
    
    func remove() {
        model.removeAccount(account)
        respond(.Delete)
    }
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface) -> ()) -> ControllerListCurrenciesInterface {
        return ControllerListCurrenciesImplementation<Model>(model: model, selected: selectedCurrency).setResponseFunction{
            if let c = $0 as? ControllerROCurrencyImplementation<Model> {
                self.oldCurrency = self.selectedCurrency
                self.selectedCurrency = c.currency
            }
            handler($0)
        }
    }
    
    func recalculate(_ value: NSDecimalNumber) -> NSDecimalNumber {
        if (oldCurrency == selectedCurrency) {
            return value
        } else {
            let rate = model.exchangeRate(selectedCurrency, to: oldCurrency)
            return value.multiplying(by: rate.0)
        }
    }
    
}

class ControllerCreateAccountImplementation<Model: ModelInterface>: Controller<()>, ControllerCreateAccountInterface {
    
    let model: Model
    
    var selectedCurrency: Model.Currency? = nil
    
    init(model: Model) {
        self.model = model
    }
    
    func create(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool {
        if (canCreate(title, initialValue: initialValue, isNegative: isNegative)) {
            if let c = selectedCurrency  {
                _ = model.addAccountAndUpdate(title, value: initialValue, isNegative: isNegative, currency: c)
                respond(())
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func canCreate(_ title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool {
        let verifyValue = isNegative ? initialValue.multiplying(by: -1) : initialValue
        return verifyValue.compare(0) != .orderedAscending && !title.isEmpty
    }
    
    func selectCurrency(handler: @escaping (ControllerROCurrencyInterface) -> ()) -> ControllerListCurrenciesInterface {
        return ControllerListCurrenciesImplementation<Model>(model: model, selected: selectedCurrency).setResponseFunction{
            if let c = $0 as? ControllerROCurrencyImplementation<Model> {
                self.selectedCurrency = c.currency
            }
            handler($0)
        }
    }
    
    func currency() -> ControllerROCurrencyInterface? {
        return selectedCurrency.map{ControllerROCurrencyImplementation<Model>(model: model, currency: $0)}
    }
    
}

class ControllerDecantImplementation<Model: ModelInterface>: Controller<(Int, Int)>, ControllerDecantInterface {
    
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    func numberOfAccounts() -> Int {
        return model.liveAccounts().count
    }
    
    func account(_ n: Int) -> ControllerROAccountInterface? {
        let accounts = model.liveAccounts()
        if (n >= accounts.count) {
            return nil
        } else {
            return ControllerROAccountImplementation(model: model, account: accounts[n])
        }
    }
    
    func decant(_ from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool {
        if let (amountFrom, amountTo) = decantData(from, to: to, amount: amount, useFromCurrency: useFromCurrency) {
            let accounts = model.liveAccounts()
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
            let lastUpdateFrom = model.updatesOfAccount(accountFrom)[0]
            let lastUpdateTo = model.updatesOfAccount(accountTo)[0]
            model.updateAccount(accountFrom, value: amountFrom, currency: model.currencyOfUpdate(lastUpdateFrom))
            model.updateAccount(accountTo, value: amountTo, currency: model.currencyOfUpdate(lastUpdateTo))
            respond((from, to))
            return true
        } else {
            return false
        }
    }
    
    func canDecant(_ from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> Bool {
        return decantData(from, to: to, amount: amount, useFromCurrency: useFromCurrency) != nil
    }
    
    func decantData(_ from: Int, to: Int, amount: NSDecimalNumber, useFromCurrency: Bool) -> (NSDecimalNumber, NSDecimalNumber)? {
        let accounts = model.liveAccounts()
        if (from >= accounts.count || to >= accounts.count || from == to || amount == 0) {
            return nil
        } else {
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
            let currencyFrom = model.currencyOfUpdate(model.updatesOfAccount(accountFrom)[0])
            let currencyTo = model.currencyOfUpdate(model.updatesOfAccount(accountTo)[0])
            let rate = model.exchangeRate(currencyFrom, to: currencyTo)
            let addAmountFrom = useFromCurrency ? amount : amount.multiplying(by: rate.0)
            let addAmountTo = useFromCurrency ? amount.multiplying(by: rate.1) : amount
            if
                let amountFrom = tryAddToAccount(accountFrom, add: addAmountFrom.multiplying(by: -1)),
                let amountTo = tryAddToAccount(accountTo, add: addAmountTo) {
                return (amountFrom, amountTo)
            } else {
                return nil
            }
        }
    }
    
    fileprivate func tryAddToAccount(_ account: Model.Account, add: NSDecimalNumber) -> NSDecimalNumber? {
        let isNegative = model.accountIsNegative(account)
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        let oldValue = model.valueOfUpdate(update)
        let newValue = oldValue.adding(add)
        let verifyValue = isNegative ? newValue.multiplying(by: -1) : newValue
        if (verifyValue.compare(0) == .orderedAscending) {
            return nil
        } else {
            return newValue
        }
    }
    
}

class ControllerSlicesImplementation<Model: ModelInterface>: Controller<()>, ControllerSlicesInterface {
    
    let model: Model
    
    let accounts: [Model.Account]
    
    init(model: Model) {
        self.model = model
        self.accounts = model.liveAccounts() + model.deadAccounts()
    }
    
    func numberOfSlices() -> Int {
        return model.slices().count + 1
    }
    
    func slice(_ n: Int) -> ControllerSliceInterface? {
        let slices = model.slices()
        if (n == 0) {
            return ControllerCurrentStatePseudoSliceImplementation(parent: self, model: model)
        } else if (n > slices.count) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: self, model: model, slice: slices[n-1], index: n-1)
        }
    }

}
