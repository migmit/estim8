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
    
    func addAccount()
    
}

protocol SubView {
    
    func show()
    
    func hide()
}

protocol EditAccountView: SubView {

}

protocol CreateAccountView: SubView {
    
}

protocol DecantView: SubView {
    
}

protocol SlicesView: SubView {
    
}