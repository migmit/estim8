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
    
    var view: MainWindowView?
    
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
        let editView = view.editAccount(editController)
        editController.setView(editView)
        editView.showSubView()
    }
    
    func remove() {
        model.removeAccount(account)
        parent.removeAccount(index)
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
    
    func name() -> String {
        return model.nameOfAccount(account)
    }
    
    func value() -> Float {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
    
    func setValue(value: Float) -> Bool {
        let isNegative = model.accountIsNegative(account)
        let verifyValue = isNegative ? -value : value
        if (verifyValue < 0) {
            return false
        } else {
            view?.hideSubView()
            model.updateAccount(account, value: value)
            parent.refreshAccount(index)
            return true
        }
    }
    
    func remove() {
        view?.hideSubView()
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
            view?.hideSubView()
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
                view?.hideSubView()
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

class ControllerSlicesImplementation<Model: ModelInterface>: ControllerSlicesInterface {
    
    let model: Model
    
    var view: SlicesView? = nil
    
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
    
    func numberOfAccounts() -> Int {
        return accounts.count
    }
    
    func slice(n: Int) -> ControllerSliceInterface? {
        let slices = model.slices()
        if (n == 0) {
            return ControllerCurrentStatePseudoSliceImplementation(parent: self, model: model, accounts: accounts)
        } else if (n > slices.count) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: self, model: model, accounts: accounts, slice: slices[n-1], index: n-1)
        }
    }
    
    func createSlice() {
        view?.createSlice()
    }
    
    func removeSlice() {
        view?.removeSlice()
    }
}

class ControllerCurrentStatePseudoSliceImplementation<Model: ModelInterface>: ControllerSliceInterface {
    
    let parent: ControllerSlicesImplementation<Model>
    
    let model: Model
    
    let accounts: [Model.Account]
    
    let allAccounts: [Model.Account]
    
    init(parent: ControllerSlicesImplementation<Model>, model: Model, accounts: [Model.Account]) {
        self.parent = parent
        self.model = model
        self.accounts = model.liveAccounts()
        self.allAccounts = accounts
    }
    
    func buttonCalledCreate() -> Bool {
        return true
    }
    
    func account(n: Int) -> ControllerROAccountInterface? {
        if (n >= accounts.count) {
            return nil
        } else {
            return ControllerROAccountImplementation(model: model, account: accounts[n])
        }
    }

    func next() -> ControllerSliceInterface? {
        let slices = model.slices()
        if (slices.isEmpty) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: parent, model: model, accounts: allAccounts, slice: slices[0], index: 0)
        }
    }
    
    func prev() -> ControllerSliceInterface? {
        return nil
    }
    
    func createOrRemove() {
        model.createSlice()
        parent.createSlice()
    }
}

class ControllerSliceImplementation<Model: ModelInterface>: ControllerSliceInterface {
    
    let parent: ControllerSlicesImplementation<Model>
    
    let model: Model
    
    let accounts: [Model.Account]
    
    let slice: Model.Slice
    
    let index: Int
    
    let updates: [Model.Account: Model.Update]
    
    init(parent: ControllerSlicesImplementation<Model>, model: Model, accounts: [Model.Account], slice: Model.Slice, index: Int) {
        self.parent = parent
        self.model = model
        self.accounts = accounts
        self.slice = slice
        self.index = index
        let updates = model.lastUpdatesOfSlice(slice)
        var updateAccounts: [Model.Account: Model.Update] = [:]
        for update in updates {
            updateAccounts.updateValue(update, forKey: model.accountOfUpdate(update))
        }
        self.updates = updateAccounts
    }
    
    func buttonCalledCreate() -> Bool {
        return false
    }
    
    func account(n: Int) -> ControllerROAccountInterface? {
        if (n >= accounts.count) {
            return nil
        } else {
            let account = accounts[n]
            if let update = updates[account] {
                return ControllerUpdateInterface(model: model, update: update)
            } else {
                return nil
            }
        }
    }
    
    func next() -> ControllerSliceInterface? {
        let slices = model.slices()
        let n = index + 1
        if (n >= slices.count) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: parent, model: model, accounts: accounts, slice: slices[n], index: n)
        }
    }
    
    func prev() -> ControllerSliceInterface? {
        if (index == 0) {
            return ControllerCurrentStatePseudoSliceImplementation(parent: parent, model: model, accounts: accounts)
        } else {
            let slices = model.slices()
            let n = index - 1
            return ControllerSliceImplementation(parent: parent, model: model, accounts: accounts, slice: slices[n], index: n)
        }
    }
    
    func createOrRemove() {
        model.removeSlice(slice)
        parent.removeSlice()
    }
}

class ControllerUpdateInterface<Model: ModelInterface>: ControllerROAccountInterface {
    
    let model: Model
    
    let update: Model.Update
    
    init(model: Model, update: Model.Update) {
        self.model = model
        self.update = update
    }
    
    func name() -> String {
        let account = model.accountOfUpdate(update)
        return model.nameOfAccount(account)
    }
    
    func value() -> Float {
        return model.valueOfUpdate(update)
    }

}