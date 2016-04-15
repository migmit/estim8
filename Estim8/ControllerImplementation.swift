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
    
    func value() -> NSDecimalNumber {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
    
    func isNegative() -> Bool {
        return model.accountIsNegative(account)
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
    
    weak var view: EditAccountView? = nil
    
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
    
    func value() -> NSDecimalNumber {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
    
    func isNegative() -> Bool {
        return model.accountIsNegative(account)
    }
    
    func setValue(value: NSDecimalNumber) -> Bool {
        if (canSetValue(value)) {
            view?.hideSubView()
            model.updateAccount(account, value: value)
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
    
}

class ControllerCreateAccountImplementation<Model: ModelInterface>: ControllerCreateAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    weak var view: CreateAccountView? = nil
    
    init(parent: ControllerImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
    }
    
    func setView(view: CreateAccountView) {
        self.view = view
    }
    
    func create(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool {
        if (canCreate(title, initialValue: initialValue, isNegative: isNegative)) {
            view?.hideSubView()
            model.addAccountAnUpdate(title, value: initialValue, isNegative: isNegative)
            parent.addAccount()
            return true
        } else {
            return false
        }
    }
    
    func canCreate(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool {
        let verifyValue = isNegative ? initialValue.decimalNumberByMultiplyingBy(-1) : initialValue
        return verifyValue.compare(0) != .OrderedAscending && !title.isEmpty
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
    
    func decant(from: Int, to: Int, amount: NSDecimalNumber) -> Bool {
        if let (amountFrom, amountTo) = decantData(from, to: to, amount: amount) {
            let accounts = model.liveAccounts()
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
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
    
    func canDecant(from: Int, to: Int, amount: NSDecimalNumber) -> Bool {
        return decantData(from, to: to, amount: amount) != nil
    }
    
    func decantData(from: Int, to: Int, amount: NSDecimalNumber) -> (NSDecimalNumber, NSDecimalNumber)? {
        let accounts = model.liveAccounts()
        if (from >= accounts.count || to >= accounts.count || from == to || amount == 0) {
            return nil
        } else {
            let accountFrom = accounts[from]
            let accountTo = accounts[to]
            if
                let amountFrom = tryAddToAccount(accountFrom, add: amount.decimalNumberByMultiplyingBy(-1)),
                let amountTo = tryAddToAccount(accountTo, add: amount) {
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
    
    func value() -> NSDecimalNumber {
        let updates = model.updatesOfAccount(account)
        let update = updates[0]
        return model.valueOfUpdate(update)
    }
    
    func isNegative() -> Bool {
        return model.accountIsNegative(account)
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
    
    func createSlice(slice: ControllerSliceInterface) {
        view?.createSlice(slice)
    }
    
    func removeSlice(slice: ControllerSliceInterface) {
        view?.removeSlice(slice)
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
    
    func sliceIndex() -> Int {
        return 0
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
        let slice = model.createSlice()
        parent.createSlice(ControllerSliceImplementation(parent: parent, model: model, accounts: allAccounts, slice: slice, index: 0))
    }
    
    func sliceDate() -> NSDate? {
        return nil
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
    
    func sliceIndex() -> Int {
        return index + 1
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
        let newSlice = prev()!
        model.removeSlice(slice)
        parent.removeSlice(newSlice)
    }
    
    func sliceDate() -> NSDate? {
        return model.dateOfSlice(slice)
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
    
    func value() -> NSDecimalNumber {
        return model.valueOfUpdate(update)
    }
    
    func isNegative() -> Bool {
        let account = model.accountOfUpdate(update)
        return model.accountIsNegative(account)
    }

}