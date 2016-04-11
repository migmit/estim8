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

}

protocol CreateAccountView: SubView {
    
}

protocol DecantView: SubView {
    
}

protocol SlicesView: SubView {
    
    func createSlice(slice: ControllerSliceInterface)
    
    func removeSlice(slice: ControllerSliceInterface)
}