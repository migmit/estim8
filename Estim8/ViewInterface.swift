//
//  ViewInterface.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol MainWindowView {
    
    func createAccount(controller: ControllerCreateAccountInterface) -> CreateAccountView
    
    func decant(controller: ControllerDecantInterface) -> DecantView
    
    func showSlices(controller: ControllerSlicesInterface) -> SlicesView
    
    func edit(controller: ControllerEditAccountInterface) -> EditAccountView
    
    func refreshAccount(n: Int)
    
    func removeAccount(n: Int)
    
}

protocol EditAccountView {
    
    func show()
    
    func hide()
}

protocol CreateAccountView {
    
}

protocol DecantView {
    
}

protocol SlicesView {
    
}