//
//  ViewInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol MainWindowView: class {
    
    func createAccount(_ controller: ControllerCreateAccountInterface) -> CreateAccountView
    
    func decant(_ controller: ControllerDecantInterface) -> DecantView
    
    func showSlices(_ controller: ControllerSlicesInterface) -> SlicesView
    
    func editAccount(_ controller: ControllerEditAccountInterface) -> EditAccountView
    
    func refreshAccount(_ n: Int)
    
    func removeAccount(_ n: Int)
    
    func addAccount()    
}

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
    
    func createSlice(_ slice: ControllerSliceInterface)
    
    func removeSlice(_ slice: ControllerSliceInterface)
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
