//
//  CurrencyItems.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerROCurrencyInterface {
    
    func name() -> String
    
    func code() -> String
    
    func symbol() -> String
    
    func rate() -> (NSDecimalNumber, NSDecimalNumber)
    
    func relative() -> ControllerROCurrencyInterface
    
}

protocol ControllerCurrencyInterface: ControllerROCurrencyInterface {
    
    func edit()
    
    func remove() -> Bool
    
    func canRemove() -> Bool
    
}
