//
//  ViewInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol MainWindowView: class {
    
    func createAccount(controller: ControllerCreateAccountInterface) -> CreateAccountView
    
    func decant(controller: ControllerDecantInterface) -> DecantView
    
    func showSlices(controller: ControllerSlicesInterface) -> SlicesView
    
    func editAccount(controller: ControllerEditAccountInterface) -> EditAccountView
    
    func refreshAccount(n: Int)
    
    func removeAccount(n: Int)
    
    func addAccount()    
}

protocol SubView: class {
    
    func showSubView()
    
    func hideSubView()
}

protocol EditAccountView: SubView {
    
    func selectCurrency(controller: ControllerListCurrenciesInterface) -> ListCurrenciesView

}

protocol CreateAccountView: SubView {
    
    func selectCurrency(controller: ControllerListCurrenciesInterface) -> ListCurrenciesView
    
}

protocol DecantView: SubView {
    
}

protocol SlicesView: SubView {
    
    func createSlice(slice: ControllerSliceInterface)
    
    func removeSlice(slice: ControllerSliceInterface)
}

protocol SelectCurrencyView: SubView {
    
}

protocol ListCurrenciesView: SubView {
    
    func createCurrency(controller: ControllerCreateCurrencyInterface) -> CreateCurrencyView
    
    func editCurrency(controller: ControllerEditCurrencyInterface) -> EditCurrencyView
    
    func refreshCurrency(n: Int)
    
    func removeCurrency(n: Int)
    
    func addCurrency()
    
}

protocol EditCurrencyView: SubView {
    
    func selectRelative(controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView
    
}

protocol CreateCurrencyView: SubView {
    
    func selectRelative(controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView
    
}

protocol ListCurrenciesViewControllerInterface {
    
    func showListCurrenciesView(sender: ListCurrenciesView)
    
}

protocol SelectCurrencyViewControllerInterface {
    
    func showSelectCurrencyView(sender: SelectCurrencyView)
    
}