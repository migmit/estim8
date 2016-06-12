//
//  CurrencyTests.swift
//  Estim8
//
//  Created by MigMit on 12/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import XCTest

class CurrencyTests: XCTestCase {
    
    var view: MocView? = nil
    
    override func setUp() {
        super.setUp()
        
        do {
            view = try setupTestCoreData()
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }

    func openList() {
        view?.mainWindow()?.tapPlusButton()
        view?.createAccount()?.expectCurrency(nil)
        view?.createAccount()?.tapCurrency()
    }
    
    func createCurrency(name: String, code: String, symbol: String, rate: NSDecimalNumber, index: Int) {
        view?.listCurrencies()?.tapPlus()
        view?.createCurrency()?.name = name
        view?.createCurrency()?.code = code
        view?.createCurrency()?.symbol = symbol
        view?.createCurrency()?.rate = rate
        view?.createCurrency()?.expectBaseCurrency(nil)
        view?.createCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.tapCurrency(index)
        view?.createCurrency()?.tapOk()

    }
    
    func testListCurrencies() {
        openList()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false))])
    }
    
    func testCreateCurrency() {
        openList()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false))])
        view?.listCurrencies()?.tapPlus()
        view?.createCurrency()?.name = "CC1"
        view?.createCurrency()?.code = "1C"
        view?.createCurrency()?.symbol = "C1"
        view?.createCurrency()?.rate = 2
        view?.createCurrency()?.expectBaseCurrency(nil)
        view?.createCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", false)])
        view?.selectCurrency()?.tapCurrency(0)
        view?.createCurrency()?.expectBaseCurrency("$")
        view?.createCurrency()?.tapOk()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("C1", (2, 0.5), "$", (true, false))])
        view?.listCurrencies()?.tapCurrency(1)
        view?.createAccount()?.expectCurrency("C1")
    }
    
    func testAddTwoCurrencies() {
        openList()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false))])
        view?.listCurrencies()?.tapPlus()
        view?.createCurrency()?.name = "CC1"
        view?.createCurrency()?.code = "1C"
        view?.createCurrency()?.symbol = "C1"
        view?.createCurrency()?.rate = 2
        view?.createCurrency()?.expectBaseCurrency(nil)
        view?.createCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", false)])
        view?.selectCurrency()?.tapCurrency(0)
        view?.createCurrency()?.expectBaseCurrency("$")
        view?.createCurrency()?.tapOk()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("C1", (2, 0.5), "$", (true, false))])
        view?.listCurrencies()?.tapCancel()
        view?.createAccount()?.expectCurrency(nil)
        view?.createAccount()?.tapCurrency()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("C1", (2, 0.5), "$", (true, false))])
        view?.listCurrencies()?.tapPlus()
        view?.createCurrency()?.name = "CC2"
        view?.createCurrency()?.code = "2C"
        view?.createCurrency()?.symbol = "C2"
        view?.createCurrency()?.rate = 4
        view?.createCurrency()?.expectBaseCurrency(nil)
        view?.createCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", false), ("C1", false)])
        view?.selectCurrency()?.tapCurrency(0)
        view?.createCurrency()?.expectBaseCurrency("$")
        view?.createCurrency()?.tapOk()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("C1", (2, 0.5), "$", (true, false)), ("C2", (4, 0.25), "$", (true, false))])
        view?.listCurrencies()?.tapCurrency(2)
        view?.createAccount()?.expectCurrency("C2")
    }
    
    func testAddWrongCurrency() {
        openList()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false))])
        view?.listCurrencies()?.tapPlus()
        view?.createCurrency()?.name = "C1"
        view?.createCurrency()?.code = "1C"
        view?.createCurrency()?.symbol = "CC1"
        view?.createCurrency()?.rate = 2
        view?.createCurrency()?.expectBaseCurrency(nil)
        view?.createCurrency()?.tapOk()
        view?.createCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.tapCancel()
        view?.createCurrency()?.expectBaseCurrency(nil)
        view?.createCurrency()?.tapOk()
        view?.createCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", false)])
        view?.selectCurrency()?.tapCurrency(0)
        view?.createCurrency()?.expectBaseCurrency("$")
        view?.createCurrency()?.name = ""
        view?.createCurrency()?.tapOk()
        view?.createCurrency()?.name = "C1"
        view?.createCurrency()?.rate = -10
        view?.createCurrency()?.tapOk()
        view?.createCurrency()?.rate = 5
        view?.createCurrency()?.tapOk()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (5, 0.2), "$", (true, false))])
    }
    
    func testRemoveCurrency() {
        openList()
        createCurrency("C1", code: "1C", symbol: "CC1", rate: 10, index: 0)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (10, 0.1), "$", (true, false))])
        createCurrency("C2", code: "2C", symbol: "CC2", rate: 20, index: 0)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (10, 0.1), "$", (true, false)), ("CC2", (20, 0.05), "$", (true, false))])
        createCurrency("C3", code: "3C", symbol: "CC3", rate: 12.5, index: 0)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (10, 0.1), "$", (true, false)), ("CC2", (20, 0.05), "$", (true, false)), ("CC3", (12.5, 0.08), "$", (true, false))])
        view?.listCurrencies()?.strikeCurrency(1, toEdit: true)
        view?.editCurrency()?.expectBaseCurrency("$")
        XCTAssertEqual((view?.editCurrency()?.name)!, "C1")
        XCTAssertEqual((view?.editCurrency()?.symbol)!, "CC1")
        XCTAssertEqual((view?.editCurrency()?.code)!, "1C")
        XCTAssertEqual((view?.editCurrency()?.rate)!, 10)
        view?.editCurrency()?.tapDelete()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC2", (20, 0.05), "$", (true, false)), ("CC3", (12.5, 0.08), "$", (true, false))])
        view?.listCurrencies()?.strikeCurrency(1, toEdit: false)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC3", (12.5, 0.08), "$", (true, false))])
    }
    
}
