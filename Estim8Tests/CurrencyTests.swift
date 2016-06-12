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
    
}
