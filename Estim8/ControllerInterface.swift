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
    
    func account(n: Int) -> ControllerAccountInterface?
    
    func createAccount()
    
    func decant()
    
    func showSlices()
}

protocol ControllerROAccountInterface {
    
    func name() -> String
    
    func value() -> Float
    
}

protocol ControllerAccountInterface: ControllerROAccountInterface {

    func edit()
    
    func remove()
    
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface {
    
    func setValue(value: Float) -> Bool
    
    func remove()
    
}

protocol ControllerCreateAccountInterface {
    
    func create(title: String, initialValue: Float, isNegative: Bool) -> Bool

}

protocol ControllerDecantInterface {
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerROAccountInterface?
    
    func decant(from: Int, to: Int, amount: Float) -> Bool
    
}

protocol ControllerSlicesInterface {
    
    func numberOfSlices() -> Int
    
    func numberOfAccounts() -> Int
    
    func slice(n: Int) -> ControllerSliceInterface?
    
}

protocol ControllerSliceInterface {
    
    func buttonCalledCreate() -> Bool
    
    func account(n: Int) -> ControllerROAccountInterface?
    
    func next() -> ControllerSliceInterface?
    
    func prev() -> ControllerSliceInterface?
    
    func createOrRemove()
}
