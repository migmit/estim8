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
    
    func createCurrency(name: String, code: String?, symbol: String, rate: NSDecimalNumber, index: Int) {
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
        view?.selectCurrency()?.expect([("$", (true, false))])
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
        view?.selectCurrency()?.expect([("$", (true, false))])
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
        view?.selectCurrency()?.expect([("$", (true, false)), ("C1", (true, false))])
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
        view?.selectCurrency()?.expect([("$", (true, false))])
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
    
    func testUpdateCurrency() {
        openList()
        createCurrency("C1", code: "1C", symbol: "CC1", rate: 25, index: 0)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (25, 0.04), "$", (true, false))])
        view?.listCurrencies()?.strikeCurrency(1, toEdit: true)
        view?.editCurrency()?.tapCancel()
        view?.listCurrencies()?.strikeCurrency(1, toEdit: true)
        XCTAssertEqual(view?.editCurrency()?.name, "C1")
        XCTAssertEqual(view?.editCurrency()?.symbol, "CC1")
        XCTAssertEqual(view?.editCurrency()?.code, "1C")
        XCTAssertEqual(view?.editCurrency()?.rate, 25)
        view?.editCurrency()?.expectBaseCurrency("$")
        view?.editCurrency()?.rate = 40
        view?.editCurrency()?.name = "C2"
        view?.editCurrency()?.symbol = "CC2"
        view?.editCurrency()?.tapOk()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC2", (40, 0.025), "$", (true, false))])
    }
    
    func testUpdateCurrencyBase() {
        openList()
        createCurrency("C1", code: "1C", symbol: "CC1", rate: 8, index: 0)
        createCurrency("C2", code: "2C", symbol: "CC2", rate: 16, index: 0)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (8, 0.125), "$", (true, false)), ("CC2", (16, 0.0625), "$", (true, false))])
        view?.listCurrencies()?.strikeCurrency(1, toEdit: true)
        XCTAssertEqual(view?.editCurrency()?.name, "C1")
        XCTAssertEqual(view?.editCurrency()?.symbol, "CC1")
        XCTAssertEqual(view?.editCurrency()?.code, "1C")
        XCTAssertEqual(view?.editCurrency()?.rate, 8)
        view?.editCurrency()?.expectBaseCurrency("$")
        view?.editCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", (true, true)), ("CC1", (false, false)), ("CC2", (true, false))])
        view?.selectCurrency()?.tapCancel()
        view?.editCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", (true, true)), ("CC1", (false, false)), ("CC2", (true, false))])
        view?.selectCurrency()?.tapCurrency(1)
        view?.selectCurrency()?.tapCurrency(2)
        view?.editCurrency()?.expectBaseCurrency("CC2")
        view?.editCurrency()?.tapBaseCurrency()
        view?.selectCurrency()?.expect([("$", (true, false)), ("CC1", (false, false)), ("CC2", (true, true))])
        view?.selectCurrency()?.tapCancel()
        view?.editCurrency()?.expectBaseCurrency("CC2")
        view?.editCurrency()?.tapOk()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (8, 0.125), "CC2", (true, false)), ("CC2", (16, 0.0625), "$", (true, false))])
    }
    
    func testCreateCurrencyAndAccount() {
        openList()
        createCurrency("C1", code: nil, symbol: "CC1", rate: 1.6, index: 0)
        view?.listCurrencies()?.tapCurrency(1)
        view?.createAccount()?.title = "AAA"
        view?.createAccount()?.value = 10
        view?.createAccount()?.isNegative = false
        view?.createAccount()?.tapOk()
        view?.mainWindow()?.expect([("AAA", 10)])
        view?.mainWindow()?.tapAccount(0)
        view?.editAccount()?.expectCurrency("CC1")
    }
    
    func testUpdateAccountCurrency() {
        view?.mainWindow()?.tapPlusButton()
        view?.createAccount()?.title = "BBB"
        view?.createAccount()?.value = 20
        view?.createAccount()?.isNegative = false
        view?.createAccount()?.expectCurrency(nil)
        view?.createAccount()?.tapOk()
        view?.createAccount()?.tapCurrency()
        view?.listCurrencies()?.expect([("$",(1,1), "$", (true, false))])
        view?.listCurrencies()?.tapCurrency(0)
        view?.createAccount()?.expectCurrency("$")
        view?.createAccount()?.tapOk()
        view?.mainWindow()?.expect([("BBB", 20)])
        view?.mainWindow()?.tapAccount(0)
        view?.editAccount()?.expectCurrency("$")
        view?.editAccount()?.tapCurrency()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, true))])
        createCurrency("C1", code: "1C", symbol: "CC1", rate: 0.8, index: 0)
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, true)), ("CC1", (0.8, 1.25), "$", (true, false))])
        view?.listCurrencies()?.tapCurrency(2)
        view?.listCurrencies()?.tapCurrency(1)
        view?.editAccount()?.expectCurrency("CC1")
        view?.editAccount()?.tapCurrency()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (0.8, 1.25), "$", (true, true))])
    }
    
    func testDecantDifferentCurrencies() {
        openList()
        createCurrency("C1", code: nil, symbol: "CC1", rate: 2.5, index: 0)
        createCurrency("C2", code: "2C", symbol: "CC2", rate: 1.25, index: 0)
        view?.listCurrencies()?.tapCurrency(1)
        view?.createAccount()?.title = "AAA"
        view?.createAccount()?.value = 100
        view?.createAccount()?.isNegative = false
        view?.createAccount()?.tapOk()
        view?.mainWindow()?.expect([("AAA", 100)])
        openList()
        view?.listCurrencies()?.expect([("$", (1,1), "$", (true, false)), ("CC1", (2.5, 0.4), "$", (true, false)), ("CC2", (1.25, 0.8), "$", (true, false))])
        view?.listCurrencies()?.tapCurrency(2)
        view?.createAccount()?.title = "BBB"
        view?.createAccount()?.value = 0
        view?.createAccount()?.isNegative = false
        view?.createAccount()?.tapOk()
        view?.mainWindow()?.expect([("AAA", 100), ("BBB", 0)])
        view?.mainWindow()?.tapDecantButton()
        view?.decant()?.fromSelected = 0
        view?.decant()?.toSelected = 1
        view?.decant()?.value = 75
        view?.decant()?.tapOk(true)
        view?.mainWindow()?.expect([("AAA", 25), ("BBB", 150)])
        view?.mainWindow()?.tapDecantButton()
        view?.decant()?.fromSelected = 0
        view?.decant()?.toSelected = 1
        view?.decant()?.value = 24
        view?.decant()?.tapOk(false)
        view?.mainWindow()?.expect([("AAA", 13), ("BBB", 174)])
    }
    
    func testDecantWithBase() {
        openList()
        createCurrency("C1", code: nil, symbol: "CC1", rate: 0.5, index: 0)
        view?.listCurrencies()?.tapCurrency(0)
        view?.createAccount()?.title = "AAA"
        view?.createAccount()?.value = 100
        view?.createAccount()?.isNegative = false
        view?.createAccount()?.expectCurrency("$")
        view?.createAccount()?.tapOk()
        view?.mainWindow()?.expect([("AAA", 100)])
        openList()
        view?.listCurrencies()?.tapCurrency(1)
        view?.createAccount()?.title = "BBB"
        view?.createAccount()?.value = -100
        view?.createAccount()?.isNegative = true
        view?.createAccount()?.expectCurrency("CC1")
        view?.createAccount()?.tapOk()
        view?.mainWindow()?.expect([("AAA", 100), ("BBB", -100)])
        view?.mainWindow()?.tapDecantButton()
        view?.decant()?.fromSelected = 0
        view?.decant()?.toSelected = 1
        view?.decant()?.value = 50
        view?.decant()?.tapOk(true)
        view?.mainWindow()?.expect([("AAA", 50), ("BBB", 0)])
        view?.mainWindow()?.tapDecantButton()
        view?.decant()?.fromSelected = 1
        view?.decant()?.toSelected = 0
        view?.decant()?.value = 50
        view?.decant()?.tapOk(true)
        view?.mainWindow()?.expect([("AAA", 75), ("BBB", -50)])
    }
    
}
