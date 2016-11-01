//
//  ViewInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol SubView: class {
    
    func showSubView()
    
    func hideSubView()
}

protocol EditAccountView: SubView {
    
    func selectCurrency(_ controller: ControllerListCurrenciesInterface) -> ListCurrenciesView
    
    func currencySelected(_ selected: ControllerROCurrencyInterface)
    
}

protocol CreateAccountView: SubView {
    
    func selectCurrency(_ controller: ControllerListCurrenciesInterface) -> ListCurrenciesView
    
    func currencySelected(_ selected: ControllerROCurrencyInterface)
    
}

protocol DecantView: SubView {
    
}

protocol SlicesView: SubView {
    
}

protocol SelectCurrencyView: SubView {
    
}

protocol ListCurrenciesView: SubView {
    
    func createCurrency(_ controller: ControllerCreateCurrencyInterface) -> CreateCurrencyView
    
    func editCurrency(_ controller: ControllerEditCurrencyInterface) -> EditCurrencyView
    
    func refreshCurrency(_ n: Int)
    
    func removeCurrency(_ n: Int)
    
    func addCurrency()
    
}

protocol EditCurrencyView: SubView {
    
    func selectRelative(_ controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView
    
    func relativeSelected(_ selected: ControllerROCurrencyInterface?)
    
}

protocol CreateCurrencyView: SubView {
    
    func selectRelative(_ controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView
    
    func relativeSelected(_ selected: ControllerROCurrencyInterface?)
    
}

protocol ListCurrenciesViewControllerInterface {
    
    func showListCurrenciesView(_ sender: ListCurrenciesView)
    
}

protocol SelectCurrencyViewControllerInterface {
    
    func showSelectCurrencyView(_ sender: SelectCurrencyView)
    
}
