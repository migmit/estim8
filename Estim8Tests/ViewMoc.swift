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
    case mainWindow(MainWindowMoc)
    case createAccount(CreateAccountMoc)
    case decant(DecantMoc)
    case slices(SlicesMoc)
    case editAccount(EditAccountMoc)
    case listCurrencies(ListCurrenciesMoc)
    case createCurrency(CreateCurrencyMoc)
    case editCurrency(EditCurrencyMoc)
    case selectCurrency(SelectCurrencyMoc)
}

class MocView {
    
    var state: MocViewState
    
    init(mainWindow: MainWindowMoc) {
        self.state = .mainWindow(mainWindow)
    }
    
    func mainWindow() -> MainWindowMoc? {
        switch state {
        case .mainWindow(let mainWindow):
            return mainWindow
        default:
            XCTFail()
            return nil
        }
    }
    
    func createAccount() -> CreateAccountMoc? {
        switch state {
        case .createAccount(let createAccount):
            return createAccount
        default:
            XCTFail()
            return nil
        }
    }
    
    func decant() -> DecantMoc? {
        switch state {
        case .decant(let decant):
            return decant
        default:
            XCTFail()
            return nil
        }
    }
    
    func slices() -> SlicesMoc? {
        switch state {
        case .slices(let slices):
            return slices
        default:
            XCTFail()
            return nil
        }
    }
    
    func editAccount() -> EditAccountMoc? {
        switch state {
        case .editAccount(let editAccount):
            return editAccount
        default:
            XCTFail()
            return nil
        }
    }
    
    func listCurrencies() -> ListCurrenciesMoc? {
        switch state {
        case .listCurrencies(let listCurrencies):
            return listCurrencies
        default:
            XCTFail()
            return nil
        }
    }
    
    func createCurrency() -> CreateCurrencyMoc? {
        switch state {
        case .createCurrency(let createCurrency):
            return createCurrency
        default:
            XCTFail()
            return nil
        }
    }
    
    func editCurrency() -> EditCurrencyMoc? {
        switch state {
        case .editCurrency(let editCurrency):
            return editCurrency
        default:
            XCTFail()
            return nil
        }
    }
    
    func selectCurrency() -> SelectCurrencyMoc? {
        switch state {
        case .selectCurrency(let selectCurrency):
            return selectCurrency
        default:
            XCTFail()
            return nil
        }
    }
}

class MainWindowMoc {
    
    let controller: ControllerInterface
    
    fileprivate var display: [(String, NSDecimalNumber)] = []
    
    var view: MocView? = nil
    
    init(controller: ControllerInterface) {
        self.controller = controller
    }
    
    func getAccount(_ index: Int) -> ControllerAccountInterface? {
        return controller.account(index) {(accountResponse) in
            switch accountResponse {
            case .Remove(let index): self.removeAccount(index)
            case .Refresh(let index): self.refreshAccount(index)
            }
        }
    }
    
    func setView(_ view: MocView) {
        self.view = view
        let n = controller.numberOfAccounts()
        if (n > 0) {
            for i in 0...(n-1) {
                if let account = getAccount(i) {
                    display.append((account.name(), account.value()))
                }
            }
        }
    }
    
    func createAccount(_ createAccount: ControllerCreateAccountInterface) -> CreateAccountView {
        return CreateAccountMoc(parent: self, controller: createAccount, view: view!)
    }
    
    func decant(_ decant: ControllerDecantInterface) -> DecantView {
        return DecantMoc(parent: self, controller: decant, view: view!)
    }
    
    func showSlices(_ slices: ControllerSlicesInterface) -> SlicesView {
        return SlicesMoc(parent: self, controller: slices, view: view!)
    }
    
    func editAccount(_ editAccount: ControllerEditAccountInterface) -> EditAccountView {
        return EditAccountMoc(parent: self, controller: editAccount, view: view!)
    }
    
    func refreshAccount(_ n: Int) {
        let account = getAccount(n)!
        display[n] = (account.name(), account.value())
    }
    
    func removeAccount(_ n: Int) {
        display.remove(at: n)
    }
    
    func addAccount() {
        let n = display.count
        if let account = getAccount(n) {
            display.append((account.name(), account.value()))
        }
    }
    
    func tapAccount(_ n: Int) {
        if let editController = getAccount(n)?.edit(){
            let editView = editAccount(editController)
            editView.showSubView()
        }
    }
    
    func tapPlusButton() {
        let createController = controller.createAccount{_ in self.addAccount()}
        let createView = createAccount(createController)
        createView.showSubView()
    }
    
    func tapDecantButton() {
        let decantController = controller.decant {(fromTo) in
            let (from, to) = fromTo
            self.refreshAccount(from)
            self.refreshAccount(to)
        }
        let decantView = decant(decantController)
        decantView.showSubView()
    }
    
    func tapHistoryButton() {
        let slicesController = controller.showSlices()
        let slicesView = showSlices(slicesController)
        slicesView.showSubView()
    }
    
    func strikeOverAccount(_ n: Int) {
        if let account = getAccount(n) {
            account.remove()
        }
    }
    
    func expect(_ expected: [(String, NSDecimalNumber)]) {
        XCTAssertEqual(display.map{$0.0}, expected.map{$0.0})
        XCTAssertEqual(display.map{$0.1}, expected.map{$0.1})
    }
}

class CreateAccountMoc: CreateAccountView {
    
    let parent: MainWindowMoc
    
    let controller: ControllerCreateAccountInterface
    
    let view: MocView
    
    var title: String = ""
    
    var value: NSDecimalNumber = 0
    
    var isNegative: Bool = false
    
    init(parent: MainWindowMoc, controller: ControllerCreateAccountInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    func showSubView() {
        view.state = .createAccount(self)
    }
    
    func hideSubView() {
        view.state = .mainWindow(parent)
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapOk() {
        if (!title.isEmpty) {
            if (controller.create(title, initialValue: value, isNegative: isNegative)) {
                hideSubView()
            }
        }
    }
    
    func tapCurrency() {
        let listCurrenciesController = controller.selectCurrency{self.currencySelected($0)}
        let listCurrenciesView = selectCurrency(listCurrenciesController)
        listCurrenciesView.showSubView()
    }
    
    func selectCurrency(_ controller: ControllerListCurrenciesInterface) -> ListCurrenciesView {
        return ListCurrenciesMoc(parent: .createAccount(self), controller: controller, view: view)
    }
    
    func currencySelected(_ selected: ControllerROCurrencyInterface) {
        // do nothing
    }
    
    func expectCurrency(_ currencySymbol: String?) {
        XCTAssertEqual(currencySymbol, controller.currency().map{$0.symbol()})
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
        view.state = .decant(self)
    }
    
    func hideSubView() {
        view.state = .mainWindow(parent)
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapOk() {
        if (controller.decant(fromSelected, to: toSelected, amount: value, useFromCurrency: useFromCurrency)) {
            hideSubView()
        }
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
        view.state = .slices(self)
    }
    
    func hideSubView() {
        view.state = .mainWindow(parent)
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
    
    func slideTo(_ n: Int) {
        if let s = State(controller: controller, number: n) {
            state = s
        }
    }
    
    func tapCreateDeleteButton() {
        numberOfSlices = controller.numberOfSlices()
        state = State(controller: controller, slice: state.slice.createOrRemove())
    }
    
    func expect(_ expect: [(String, NSDecimalNumber)?], buttonTitle: String, prevEnabled: Bool, nextEnabled: Bool) {
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
        view.state = .editAccount(self)
    }
    
    func hideSubView() {
        view.state = .mainWindow(parent)
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapOk() {
        if (controller.setValue(value)) {
            hideSubView()
        }
    }
    
    func tapDeleteButton() {
        controller.remove()
        hideSubView()
    }
    
    func tapCurrency() {
        let listCurrenciesController = controller.selectCurrency{self.currencySelected($0)}
        let listCurrenciesView = selectCurrency(listCurrenciesController)
        listCurrenciesView.showSubView()
    }
    
    func selectCurrency(_ controller: ControllerListCurrenciesInterface) -> ListCurrenciesView {
        return ListCurrenciesMoc(parent: .editAccount(self), controller: controller, view: view)
    }
    
    func currencySelected(_ selected: ControllerROCurrencyInterface) {
        //do nothing
    }
    
    func expectCurrency(_ currencySymbol: String) {
        XCTAssertEqual(currencySymbol, controller.currency().symbol())
    }
    
    func recalculate() -> NSDecimalNumber {
        return controller.recalculate(controller.value())
    }
}

enum ListCurrenciesParent {
    case editAccount(EditAccountMoc)
    case createAccount(CreateAccountMoc)
}

class ListCurrenciesMoc: ListCurrenciesView {
    
    fileprivate var display: [(String, (NSDecimalNumber, NSDecimalNumber), String?, (Bool, Bool))] // Currency symbol, rate, relative symbol, (can select, marked)
    
    let parent: ListCurrenciesParent
    
    let controller: ControllerListCurrenciesInterface
    
    let view: MocView
    
    init(parent: ListCurrenciesParent, controller: ControllerListCurrenciesInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
        self.display = []
    }
    
    func showSubView() {
        view.state = .listCurrencies(self)
        let n = controller.numberOfCurrencies()
        if (n > 0) {
            for i in 0...(n-1) {
                if let currency = controller.currency(i) {
                    self.display.append((currency.symbol(), currency.rate(), currency.relative()?.symbol(), (controller.canSelect(i), controller.marked(i))))
                }
            }
        }
    }
    
    func hideSubView() {
        switch parent {
        case .editAccount(let editAccount):
            view.state = .editAccount(editAccount)
        case .createAccount(let createAccount):
            view.state = .createAccount(createAccount)
        }
    }
    
    func createCurrency(_ controller: ControllerCreateCurrencyInterface) -> CreateCurrencyView {
        return CreateCurrencyMoc(parent: self, controller: controller, view: view)
    }
    
    func editCurrency(_ controller: ControllerEditCurrencyInterface) -> EditCurrencyView {
        return EditCurrencyMoc(parent: self, controller: controller, view: view)
    }
    
    func refreshCurrency(_ n: Int) {
        if let currency = controller.currency(n) {
            display[n] = (currency.symbol(), currency.rate(), currency.relative()?.symbol(), (controller.canSelect(n), controller.marked(n)))
        }
    }
    
    func removeCurrency(_ n: Int) {
        display.remove(at: n)
    }
    
    func addCurrency() {
        let n = display.count
        if let currency = controller.currency(n) {
            display.append((currency.symbol(), currency.rate(), currency.relative()?.symbol(), (controller.canSelect(n), controller.marked(n))))
        }
    }
    
    func tapCurrency(_ n: Int) {
        if (controller.select(n)) {
            hideSubView()
        }
    }
    
    func strikeCurrency(_ n: Int, toEdit: Bool) {
        if (toEdit) {
            if let currencyController = controller.currency(n) {
                let editController = currencyController.edit{(response) in
                    self.controller.refreshData()
                    switch response {
                    case .Refresh(let currencies):
                        self.refreshCurrency(n)
                        currencies.forEach{self.refreshCurrency($0)}
                    case .Delete:
                        self.removeCurrency(n)
                    }
                }
                let editView = editCurrency(editController)
                editView.showSubView()
            }
        } else {
            if (controller.currency(n)?.remove() ?? false) {
                controller.refreshData()
                removeCurrency(n)
            }
        }
    }
    
    func tapPlus() {
        let createController = controller.createCurrency1{self.addCurrency()}
        let createView = createCurrency(createController)
        createView.showSubView()
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func expect(_ expected: [(String, (NSDecimalNumber, NSDecimalNumber), String?, (Bool, Bool))]) {
        XCTAssertEqual(display.map{$0.0}, expected.map{$0.0})
        XCTAssertEqual(display.map{$0.1.0}, expected.map{$0.1.0})
        XCTAssertEqual(display.map{$0.1.1}, expected.map{$0.1.1})
        if (display.count == expected.count && expected.count > 0) {
            for i in 0...(expected.count - 1) {
                XCTAssertEqual(display[i].2, expected[i].2)
            }
        }
        XCTAssertEqual(display.map{$0.3.0}, expected.map{$0.3.0})
        XCTAssertEqual(display.map{$0.3.1}, expected.map{$0.3.1})
    }
}

class CreateCurrencyMoc: CreateCurrencyView {
    
    var name: String = ""
    
    var code: String? = ""
    
    var symbol: String = ""
    
    var rate: NSDecimalNumber = 1
    
    let parent: ListCurrenciesMoc
    
    let controller: ControllerCreateCurrencyInterface
    
    let view: MocView
    
    init(parent: ListCurrenciesMoc, controller: ControllerCreateCurrencyInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    func showSubView() {
        view.state = .createCurrency(self)
    }
    
    func hideSubView() {
        view.state = .listCurrencies(parent)
    }
    
    func selectRelative(_ controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView {
        return SelectCurrencyMoc(parent: .createCurrency(self), controller: controller, view: view)
    }
    
    func relativeSelected(_ selected: ControllerROCurrencyInterface?) {
        //do nothing
    }
    
    func expectBaseCurrency(_ currencySymbol: String?) {
        XCTAssertEqual(currencySymbol, controller.relative().flatMap{$0.symbol()})
    }
    
    func tapOk() {
        if (controller.create(name, code: code, symbol: symbol, rate: (rate, NSDecimalNumber.one.dividing(by: rate)))) {
            hideSubView()
        }
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapBaseCurrency() {
        let selectCurrencyController = controller.selectCurrency{self.relativeSelected($0)}
        let selectCurrencyView = selectRelative(selectCurrencyController)
        selectCurrencyView.showSubView()
    }
    
}

class EditCurrencyMoc: EditCurrencyView {
    
    var name: String = ""
    
    var code: String? = ""
    
    var symbol: String = ""
    
    var rate: NSDecimalNumber = 1
    
    let parent: ListCurrenciesMoc
    
    let controller: ControllerEditCurrencyInterface
    
    let view: MocView
    
    init(parent: ListCurrenciesMoc, controller: ControllerEditCurrencyInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
    }
    
    func showSubView() {
        view.state = .editCurrency(self)
        name = controller.name()
        code = controller.code()
        symbol = controller.symbol()
        rate = controller.rate().0
    }
    
    func hideSubView() {
        view.state = .listCurrencies(parent)
    }
    
    func selectRelative(_ controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView {
        return SelectCurrencyMoc(parent: .editCurrency(self), controller: controller, view: view)
    }
    
    func relativeSelected(_ selected: ControllerROCurrencyInterface?) {
        //do nothing
    }
    
    func expectBaseCurrency(_ currencySymbol: String?) {
        XCTAssertEqual(currencySymbol, controller.relative()?.symbol())
    }
    
    func tapOk() {
        if (controller.setCurrency(name, code: code, symbol: symbol, rate: (rate, NSDecimalNumber.one.dividing(by: rate)))) {
            hideSubView()
        }
    }
    
    func tapCancel() {
        hideSubView()
    }
    
    func tapDelete() {
        if (controller.remove()) {
            hideSubView()
        }
    }
    
    func tapBaseCurrency() {
        let selectCurrencyController = controller.selectCurrency{self.relativeSelected($0)}
        let selectCurrencyView = selectRelative(selectCurrencyController)
        selectCurrencyView.showSubView()
    }
    
}

enum SelectCurrencyParent {
    case createCurrency(CreateCurrencyMoc)
    case editCurrency(EditCurrencyMoc)
}

class SelectCurrencyMoc: SelectCurrencyView {
    
    fileprivate let display: [(String, (Bool, Bool))?] // Symbol, (canSelect, marked)
    
    let parent: SelectCurrencyParent
    
    let controller: ControllerSelectCurrencyInterface
    
    let view: MocView
    
    init(parent: SelectCurrencyParent, controller: ControllerSelectCurrencyInterface, view: MocView) {
        self.parent = parent
        self.controller = controller
        self.view = view
        var allCurrencies: [(String, (Bool, Bool))?] = []
        let n = controller.numberOfCurrencies()
        for i in 0...(n-1) {
            if let c = controller.currency(i) {
                allCurrencies.append((c.symbol(), (controller.canSelect(i), controller.marked(i))))
            } else {
                allCurrencies.append(nil)
            }
        }
        self.display = allCurrencies
    }
    
    func showSubView() {
        view.state = .selectCurrency(self)
    }
    
    func hideSubView() {
        switch parent {
        case .createCurrency(let createCurrency):
            view.state = .createCurrency(createCurrency)
        case .editCurrency(let editCurrency):
            view.state = .editCurrency(editCurrency)
        }
    }
    
    func expect(_ expected: [(String, (Bool, Bool))?]) {
        XCTAssertEqual(display.count, expected.count)
        if (display.count == expected.count && expected.count > 0) {
            for n in 0...(expected.count - 1) {
                if let e = expected[n] {
                    XCTAssertNotNil(display[n])
                    if let d = display[n] {
                        XCTAssertEqual(d.0, e.0)
                        XCTAssertEqual(d.1.0, e.1.0)
                        XCTAssertEqual(d.1.1, e.1.1)
                    }
                } else {
                    XCTAssertNil(display[n])
                }
            }
        }
    }
    
    func tapCurrency(_ n: Int) {
        if (controller.select(n)) {
            hideSubView()
        }
    }
    
    func tapCancel() {
        hideSubView()
    }
    
}
