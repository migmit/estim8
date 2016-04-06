//
//  ControllerInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerInterface {
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerAccountInterface
    
    func createAccount(view: ControllerCreateAccountInterface -> CreateAccountView)
    
    func decant(view: ControllerDecantInterface -> DecantView)
    
    func showSlices(view: ControllerSlicesInterface -> SlicesView)
}

protocol ControllerROAccountInterface {
    
    func name() -> String
    
    func value() -> Float
    
}

protocol ControllerAccountInterface: ControllerROAccountInterface {

    func edit(view: ControllerEditAccountInterface -> EditAccountView)
    
}

protocol ControllerEditAccountInterface {
    
    func setValue(value: Float) -> Bool
    
    func remove()
    
}

protocol ControllerCreateAccountInterface {
    
    func create(title: String, initialValue: Float, isNegative: Bool) -> Bool

}

protocol ControllerDecantInterface {
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerAccountInterface
    
    func decant(amount: Float) -> Bool
    
}

protocol ControllerSlicesInterface {
    
    func numberOfSlices() -> Int
    
    func numberOfAccounts() -> Int
    
    func slice(n: Int) -> ControllerSliceInterface
    
}

protocol ControllerSliceInterface {
    
    func account(n: Int) -> ControllerROAccountInterface
    
    func next() -> ControllerSliceInterface?
    
    func prev() -> ControllerSliceInterface?
    
}
