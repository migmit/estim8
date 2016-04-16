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
    
    func value() -> NSDecimalNumber
    
    func isNegative() -> Bool
    
}

protocol ControllerAccountInterface: ControllerROAccountInterface {

    func edit()
    
    func remove()
    
}

protocol ControllerEditAccountInterface: ControllerROAccountInterface {
    
    func setValue(value: NSDecimalNumber) -> Bool
    
    func canSetValue(value: NSDecimalNumber) -> Bool
    
    func remove()
    
}

protocol ControllerCreateAccountInterface {
    
    func create(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool
    
    func canCreate(title: String, initialValue: NSDecimalNumber, isNegative: Bool) -> Bool

}

protocol ControllerDecantInterface {
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerROAccountInterface?
    
    func decant(from: Int, to: Int, amount: NSDecimalNumber) -> Bool
    
    func canDecant(from: Int, to: Int, amount: NSDecimalNumber) -> Bool
    
}

protocol ControllerSlicesInterface {
    
    func numberOfSlices() -> Int
    
    func slice(n: Int) -> ControllerSliceInterface?
    
}

protocol ControllerTransitionInterface {
    
}

protocol ControllerTransitionAccountInterface: ControllerROAccountInterface {
    
    func transition() -> ControllerTransitionInterface
    
}

protocol ControllerSliceInterface {
    
    func sliceIndex() -> Int
    
    func buttonCalledCreate() -> Bool
    
    func numberOfAccounts() -> Int
    
    func account(n: Int) -> ControllerTransitionAccountInterface?
    
    func whereToMove(account: ControllerTransitionInterface) -> (Int, Bool)?
    
    func next() -> ControllerSliceInterface?
    
    func prev() -> ControllerSliceInterface?
    
    func createOrRemove()
    
    func sliceDate() -> NSDate?
}
