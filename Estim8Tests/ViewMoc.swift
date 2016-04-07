//
//  ViewMoc.swift
//  Estim8
//
//  Created by MigMit on 07/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

enum MocViewState {
    case MainWindow(MainWindowMoc)
    case CreateAccount(CreateAccountMoc)
    case Decant(DecantMoc)
    case Slices(SlicesMoc)
    case EditAccount(EditAccountMoc)
}

class MocView {
    
    var state: MocViewState
    
    init(mainWindow: MainWindowMoc) {
        self.state = .MainWindow(mainWindow)
    }
}

class MainWindowMoc: MainWindowView {
    
    let controller: ControllerInterface
    
    var display: [(String, Float)] = []
    
    let view: MocView
    
    init(controller: ControllerInterface, view: MocView) {
        self.controller = controller
        self.view = view
        let n = controller.numberOfAccounts()
        for i in 0...(n-1) {
            if let account = controller.account(i) {
                display.append((account.name(), account.value()))
            }
        }
    }
    
    func createAccount(createAccount: ControllerCreateAccountInterface) -> CreateAccountView {
        return CreateAccountMoc(parent: self, controller: createAccount, view: view)
    }
    
    func decant(decant: ControllerDecantInterface) -> DecantView {
        return DecantMoc(parent: self, controller: decant, view: view)
    }
    
    func showSlices(slices: ControllerSlicesInterface) -> SlicesView {
        return SlicesMoc(parent: self, controller: slices, view: view)
    }
    
    func editAccount(editAccount: ControllerEditAccountInterface) -> EditAccountView {
        return EditAccountMoc(parent: self, controller: editAccount, view: view)
    }
    
    func refreshAccount(n: Int) {
        let account = controller.account(n)!
        display[n] = (account.name(), account.value())
    }
    
    func removeAccount(n: Int) {
        display.removeAtIndex(n)
    }
    
    func addAccount() {
        let n = display.count
        if let account = controller.account(n) {
            display.append((account.name(), account.value()))
        }
    }
    
    func tapAccount(n: Int) {
        controller.account(n)?.edit()
    }
    
    func tapPlusButton() {
        controller.createAccount()
    }
    
    func tapDecantButton() {
        controller.decant()
    }
    
    func tapHistoryButton() {
        controller.showSlices()
    }
}

class CreateAccountMoc: CreateAccountView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerCreateAccountInterface
    
    let view: MocView
    
    init(parent: MainWindowMoc, controller: ControllerCreateAccountInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    func showSubView() {
        
    }
    
    func hideSubView() {
        
    }
   }

class DecantMoc: DecantView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerDecantInterface
    
    let view: MocView
    
    init(parent: MainWindowMoc, controller: ControllerDecantInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    //
    
    func showSubView() {
        
    }
    
    func hideSubView() {
        
    }
}

class SlicesMoc: SlicesView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerSlicesInterface
    
    let view: MocView
    
    init(parent: MainWindowMoc, controller: ControllerSlicesInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    //
    
    func showSubView() {
        
    }
    
    func hideSubView() {
        
    }
    
    func createSlice() {
        
    }
    
    func removeSlice() {
        
    }
}

class EditAccountMoc: EditAccountView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerEditAccountInterface
    
    let view: MocView
    
    init(parent: MainWindowMoc, controller: ControllerEditAccountInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    //
    
    func showSubView() {
        
    }
    
    func hideSubView() {
        
    }
}