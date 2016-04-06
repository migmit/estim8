//
//  Controller.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerImplementation<Model: ModelInterface>: ControllerInterface {
    
    let model: Model
    
    let view: MainWindowView
    
    init(model: Model, view: MainWindowView) {
        self.model = model
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
            return ControllerAccountImplementation(parent: self, model: model, view: view, account: accounts[n], index: n)
        }
    }
    
    func refreshAccount(n: Int) {
        view.refreshAccount(n)
    }
    
    func removeAccount(n: Int) {
        view.removeAccount(n)
    }
    
    func addAccount() {
        view.addAccount()
    }
    
    func createAccount() {
        let createController = ControllerCreateAccountImplementation(parent: self, model: model)
        let createView = view.createAccount(createController)
        createController.setView(createView)
        createView.show()
    }
    
    func decant() {
        let decantController = ControllerDecantImplementation(parent: self, model: model)
        let decantView = view.decant(decantController)
        decantController.setView(decantView)
        decantView.show()
    }
    
    //
    
    func showSlices() {
        
    }
    
}

class ControllerAccountImplementation<Model: ModelInterface>: ControllerAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    let view: MainWindowView
    
    let account: Model.Account
    
    let index: Int
    
    init(parent: ControllerImplementation<Model>, model: Model, view: MainWindowView, account: Model.Account, index: Int) {
        self.parent = parent
        self.model = model
        self.view = view
        self.account = account
        self.index = index
    }
    
    func name() -> String {
        return model.nameOfAccount(account)
    }
    
    func value() -> Float {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
    
    func edit() {
        let editController = ControllerEditAccountImplementation(parent: parent, model: model, account: account, index: index)
        let editView = view.edit(editController)
        editController.setView(editView)
        editView.show()
    }
}

class ControllerEditAccountImplementation<Model: ModelInterface>: ControllerEditAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    var view: EditAccountView? = nil
    
    let account: Model.Account
    
    let index: Int
    
    init(parent: ControllerImplementation<Model>, model: Model, account: Model.Account, index: Int) {
        self.parent = parent
        self.model = model
        self.account = account
        self.index = index
    }
    
    func setView(view: EditAccountView) {
        self.view = view
    }
    
    func setValue(value: Float) -> Bool {
        let isNegative = model.accountIsNegative(account)
        let verifyValue = isNegative ? -value : value
        if (verifyValue < 0) {
            return false
        } else {
            view?.hide()
            model.updateAccount(account, value: value)
            parent.refreshAccount(index)
            return true
        }
    }
    
    func remove() {
        view?.hide()
        model.removeAccount(account)
        parent.removeAccount(index)
    }
    
}

class ControllerCreateAccountImplementation<Model: ModelInterface>: ControllerCreateAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    var view: CreateAccountView? = nil
    
    init(parent: ControllerImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: CreateAccountView) {
        self.view = view
    }
    
    func create(title: String, initialValue: Float, isNegative: Bool) -> Bool {
        let verifyValue = isNegative ? -initialValue : initialValue
        if (verifyValue < 0) {
            return false
        } else {
            view?.hide()
            model.addAccountAnUpdate(title, value: initialValue, isNegative: isNegative)
            parent.addAccount()
            return true
        }
    }
}

class ControllerDecantImplementation<Model: ModelInterface>: ControllerDecantInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    var view: DecantView? = nil
    
    init(parent: ControllerImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: DecantView) {
        self.view = view
    }
    
    func numberOfAccounts() -> Int {
        return model.liveAccounts().count + model.deadAccounts().count
    }
    
    func account(n: Int) -> ControllerROAccountInterface? {
        let accounts = model.liveAccounts()
        if (n >= accounts.count) {
            return nil
        } else {
            return ControllerROAccountImplementation(model: model, account: accounts[n])
        }
    }
    
    func decant(from: Int, to: Int, amount: Float) -> Bool {
        let accounts = model.liveAccounts()
        if (from >= accounts.count || to >= accounts.count) {
            return false
        } else {
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
            if
                let amountFrom = tryAddToAccount(accountFrom, add: -amount),
                let amountTo = tryAddToAccount(accountTo, add: amount) {
                view?.hide()
                model.updateAccount(accountFrom, value: amountFrom)
                model.updateAccount(accountTo, value: amountTo)
                parent.refreshAccount(from)
                parent.refreshAccount(to)
                return true
            } else {
                return false
            }
        }
    }
    
    private func tryAddToAccount(account: Model.Account, add: Float) -> Float? {
        let isNegative = model.accountIsNegative(account)
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        let oldValue = model.valueOfUpdate(update)
        let newValue = oldValue + add
        let verifyValue = isNegative ? -newValue : newValue
        if (verifyValue < 0) {
            return nil
        } else {
            return newValue
        }
    }
    
}

class ControllerROAccountImplementation<Model: ModelInterface>: ControllerROAccountInterface {
    
    let model: Model
    
    let account: Model.Account
    
    init(model: Model, account: Model.Account) {
        self.model = model
        self.account = account
    }

    func name() -> String {
        return model.nameOfAccount(account)
    }
    
    func value() -> Float {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
}