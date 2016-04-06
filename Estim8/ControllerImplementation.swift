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
            return ControllerAccountImplementation<Model>(model: model, view: view, account: accounts[n])
        }
    }
    
    //
    
    func createAccount() {
        
    }
    
    func decant() {
        
    }
    
    func showSlices() {
        
    }
    
}

class ControllerAccountImplementation<Model: ModelInterface>: ControllerAccountInterface {
    
    let model: Model
    
    let view: MainWindowView
    
    let account: Model.Account
    
    init(model: Model, view: MainWindowView, account: Model.Account) {
        self.model = model
        self.view = view
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
    
    //
    
    func edit() {
        
    }
}