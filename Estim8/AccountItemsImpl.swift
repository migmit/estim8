//
//  AccountItemsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

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
    
    func currency() -> ControllerROCurrencyInterface {
        let lastUpdate = model.updatesOfAccount(account)[0]
        return ControllerROCurrencyImplementation(model: model, currency: model.currencyOfUpdate(lastUpdate))
    }
}

class ControllerAccountImplementation<Model: ModelInterface>: ControllerAccountInterface {
    
    let parent: ControllerImplementation<Model>
    
    let model: Model
    
    let account: Model.Account
    
    let index: Int
    
    let handler: (EditResponse) -> ()
    
    init(parent: ControllerImplementation<Model>, model: Model, account: Model.Account, index: Int, handler: @escaping (EditResponse) -> ()) {
        self.parent = parent
        self.model = model
        self.account = account
        self.index = index
        self.handler = handler
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
    
    func edit() -> ControllerEditAccountInterface {
        let editController = ControllerEditAccountImplementation(model: model, account: account)
        editController.setResponseFunction(handler)
        return editController
    }
    
    func remove() {
        model.removeAccount(account)
        handler(.Delete)
    }
    
    func currency() -> ControllerROCurrencyInterface {
        let lastUpdate = model.updatesOfAccount(account)[0]
        return ControllerROCurrencyImplementation(model: model, currency: model.currencyOfUpdate(lastUpdate))
    }
}

class ControllerTransitionImplementation<Model: ModelInterface>: ControllerTransitionInterface {
    
    let account: Model.Account
    
    init(account: Model.Account) {
        self.account = account
    }
}

class ControllerTransitionAccountImplementation<Model: ModelInterface>: ControllerTransitionAccountInterface {
    
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
    
    func currency() -> ControllerROCurrencyInterface {
        let lastUpdate = model.updatesOfAccount(account)[0]
        return ControllerROCurrencyImplementation(model: model, currency: model.currencyOfUpdate(lastUpdate))
    }
    
    func transition() -> ControllerTransitionInterface {
        return ControllerTransitionImplementation<Model>(account: account)
    }
    
}

class ControllerUpdateInterface<Model: ModelInterface>: ControllerTransitionAccountInterface {
    
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
    
    func currency() -> ControllerROCurrencyInterface {
        return ControllerROCurrencyImplementation(model: model, currency: model.currencyOfUpdate(update))
    }
    
    func transition() -> ControllerTransitionInterface {
        return ControllerTransitionImplementation<Model>(account: model.accountOfUpdate(update))
    }
    
}
