//
//  CurrencyItems.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerCurrencyHolderInterface {
    
}

protocol ControllerROCurrencyInterface: ControllerCurrencyHolderInterface {
    
    func name() -> String
    
    func symbol() -> String
    
}

protocol ControllerROCurrenciesInterface { // SUBJECT TO REMOVAL!
    
    func numberOfCurrencies() -> Int
    
    func currency(n: Int) -> ControllerROCurrencyInterface?

}