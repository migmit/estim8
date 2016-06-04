//
//  ViewMoc.swift
//  Estim8
//
//  Created by MigMit on 07/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation
import XCTest

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
    
    func mainWindow() -> MainWindowMoc? {
        switch state {
        case .MainWindow(let mainWindow):
            return mainWindow
        default:
            XCTFail()
            return nil
        }
    }
    
    func createAccount() -> CreateAccountMoc? {
        switch state {
        case .CreateAccount(let createAccount):
            return createAccount
        default:
            XCTFail()
            return nil
        }
    }
    
    func decant() -> DecantMoc? {
        switch state {
        case .Decant(let decant):
            return decant
        default:
            XCTFail()
            return nil
        }
    }
    
    func slices() -> SlicesMoc? {
        switch state {
        case .Slices(let slices):
            return slices
        default:
            XCTFail()
            return nil
        }
    }
    
    func editAccount() -> EditAccountMoc? {
        switch state {
        case .EditAccount(let editAccount):
            return editAccount
        default:
            XCTFail()
            return nil
        }
    }
}

class MainWindowMoc: MainWindowView {
    
    let controller: ControllerInterface
    
    private var display: [(String, NSDecimalNumber)] = []
    
    var view: MocView? = nil
    
    init(controller: ControllerInterface) {
        self.controller = controller
        let n = controller.numberOfAccounts()
        if (n > 0) {
            for i in 0...(n-1) {
                if let account = controller.account(i) {
                    display.append((account.name(), account.value()))
                }
            }
        }
    }
    
    func setView(view: MocView) {
        self.view = view
    }
    
    func createAccount(createAccount: ControllerCreateAccountInterface) -> CreateAccountView {
        return CreateAccountMoc(parent: self, controller: createAccount, view: view!)
    }
    
    func decant(decant: ControllerDecantInterface) -> DecantView {
        return DecantMoc(parent: self, controller: decant, view: view!)
    }
    
    func showSlices(slices: ControllerSlicesInterface) -> SlicesView {
        return SlicesMoc(parent: self, controller: slices, view: view!)
    }
    
    func editAccount(editAccount: ControllerEditAccountInterface) -> EditAccountView {
        return EditAccountMoc(parent: self, controller: editAccount, view: view!)
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
    
    func strikeOverAccount(n: Int) {
        if let account = controller.account(n) {
            account.remove()
        }
    }
    
    func expect(expected: [(String, NSDecimalNumber)]) {
        XCTAssert(display.map{$0.0} == expected.map{$0.0})
        XCTAssert(display.map{$0.1} == expected.map{$0.1})
    }
}

class CreateAccountMoc: CreateAccountView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerCreateAccountInterface
    
    let view: MocView
    
    let currencies: [String]
    
    var title: String = ""
    
    var value: NSDecimalNumber = 0
    
    var isNegative: Bool = false
    
    var selectedCurrency: Int = 0
    
    init(parent: MainWindowMoc, controller: ControllerCreateAccountInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
        var currencyNames: [String] = []
        let currenciesList = controller.currencies()
        let n = currenciesList.numberOfCurrencies()
        for i in 0...(n-1) {
            if let currency = currenciesList.currency(i) {
                currencyNames.append(currency.name())
            }
        }
        self.currencies = currencyNames
    }
    
    func showSubView() {
        view.state = .CreateAccount(self)
    }
    
    func hideSubView() {
        view.state = .MainWindow(parent)
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapOk() {
        if (!title.isEmpty) {
            if let currency = controller.currencies().currency(selectedCurrency) {
                controller.create(title, initialValue: value, currency: currency, isNegative: isNegative)
            }
        }
    }
    
    func expectCurrencies(expected: [String?]) {
        XCTAssert(expected.count == currencies.count)
        for i in 0...(currencies.count - 1) {
            XCTAssert(expected[i] == nil || expected[i] == currencies[i])
        }
    }
}

class DecantMoc: DecantView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerDecantInterface
    
    let view: MocView
    
    let fromAccounts: [(String, NSDecimalNumber)]
    
    let toAccounts: [(String, NSDecimalNumber)]
    
    var fromSelected: Int = 0
    
    var toSelected: Int = 0
    
    var value: NSDecimalNumber = 0
    
    var useFromCurrency: Bool = true
    
    init(parent: MainWindowMoc, controller: ControllerDecantInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
        let n = controller.numberOfAccounts()
        var allAccounts: [(String, NSDecimalNumber)] = []
        if (n > 0) {
            for i in 0...(n-1) {
                if let account = controller.account(i) {
                    allAccounts.append((account.name(), account.value()))
                }
            }
        }
        self.fromAccounts = allAccounts
        self.toAccounts = allAccounts
    }
    
    func showSubView() {
        view.state = .Decant(self)
    }
    
    func hideSubView() {
        view.state = .MainWindow(parent)
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapOk() {
        controller.decant(fromSelected, to: toSelected, amount: value, useFromCurrency: useFromCurrency)
    }
}

class SlicesMoc: SlicesView {
    
    class State {
        
        let slice: ControllerSliceInterface
        
        let display: [(String, NSDecimalNumber)?]
        
        let buttonTitle: String
        
        let prevEnabled: Bool
        
        let nextEnabled: Bool
        
        init(controller: ControllerSlicesInterface, slice: ControllerSliceInterface) {
            self.slice = slice
            var display: [(String, NSDecimalNumber)?] = []
            let n = slice.numberOfAccounts()
            if (n > 0) {
                for i in 0...(n-1) {
                    if let account = slice.account(i) {
                        display.append((account.name(), account.value()))
                    } else {
                        display.append(nil)
                    }
                }
            }
            self.display = display
            self.buttonTitle = slice.buttonCalledCreate() ? "Create" : "Delete"
            if let _ = slice.prev() {
                self.prevEnabled = true
            } else {
                self.prevEnabled = false
            }
            if let _ = slice.next() {
                self.nextEnabled = true
            } else {
                self.nextEnabled = false
            }
        }
        
        convenience init?(controller: ControllerSlicesInterface, number: Int) {
            if let slice = controller.slice(number) {
                self.init(controller: controller, slice: slice)
            } else {
                return nil
            }
        }
    }
    
    let parent: MainWindowMoc
    
    let controller: ControllerSlicesInterface
    
    let view: MocView
    
    var numberOfSlices: Int
    
    var state: State
    
    init(parent: MainWindowMoc, controller: ControllerSlicesInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
        self.numberOfSlices = controller.numberOfSlices()
        state = State(controller: controller, number: 0)!
    }
    
    func showSubView() {
        view.state = .Slices(self)
    }
    
    func hideSubView() {
        view.state = .MainWindow(parent)
    }
    
    func createSlice(slice: ControllerSliceInterface) {
        numberOfSlices += 1
        state = State(controller: controller, number: slice.sliceIndex())!
    }
    
    func removeSlice(slice: ControllerSliceInterface) {
        numberOfSlices -= 1
        state = State(controller: controller, number: slice.sliceIndex())!
    }
    
    func tapPrevButton() {
        if let s = state.slice.prev() {
            state = State(controller: controller, slice: s)
        }
    }
    
    func tapNextButton() {
        if let s = state.slice.next() {
            state = State(controller: controller, slice: s)
        }
    }
    
    func tapCloseButton() {
        hideSubView()
    }
    
    func slideTo(n: Int) {
        if let s = State(controller: controller, number: n) {
            state = s
        }
    }
    
    func tapCreateDeleteButton() {
        state.slice.createOrRemove()
    }
    
    func expect(expect: [(String, Float)?], buttonTitle: String, prevEnabled: Bool, nextEnabled: Bool) {
        if (state.display.count == expect.count) {
            if (expect.count > 0) {
                for i in 0...(expect.count-1) {
                    if let d = state.display[i], let e = expect[i] {
                        XCTAssertEqual(d.0, e.0)
                        XCTAssertEqual(d.1, e.1)
                    } else {
                        XCTAssertNil(state.display[i])
                        XCTAssertNil(expect[i])
                    }
                }
            }
        } else {
            XCTFail()
        }
        XCTAssertEqual(buttonTitle, state.buttonTitle)
        XCTAssertEqual(prevEnabled, state.prevEnabled)
        XCTAssertEqual(nextEnabled, state.nextEnabled)
    }
}

class EditAccountMoc: EditAccountView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerEditAccountInterface
    
    let view: MocView
    
    let name: String
    
    var value: NSDecimalNumber
    
    init(parent: MainWindowMoc, controller: ControllerEditAccountInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
        self.name = controller.name()
        self.value = controller.value()
    }
    
    func showSubView() {
        view.state = .EditAccount(self)
    }
    
    func hideSubView() {
        view.state = .MainWindow(parent)
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapOk() {
        controller.setValue(value, currency: controller.currency())
    }
    
    func tapDeleteButton() {
        controller.remove()
    }
}