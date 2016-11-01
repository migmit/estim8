//
//  ViewInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ListCurrenciesViewControllerInterface {
    
    func showListCurrenciesView(_ sender: ControllerListCurrenciesInterface)
    
}

protocol SelectCurrencyViewControllerInterface {
    
    func showSelectCurrencyView(_ sender: ControllerSelectCurrencyInterface)
    
}
