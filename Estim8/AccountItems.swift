//
//  Items.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerROAccountInterface {
    
    func name() -> String
    
    func value() -> NSDecimalNumber
    
    func isNegative() -> Bool
    
    func currency() -> ControllerROCurrencyInterface
    
}

protocol ControllerAccountInterface: ControllerROAccountInterface {
    
    func edit() -> ControllerEditAccountInterface
    
    func remove()
    
}

protocol ControllerTransitionInterface {
    
}

protocol ControllerTransitionAccountInterface: ControllerROAccountInterface {
    
    func transition() -> ControllerTransitionInterface
    
}
