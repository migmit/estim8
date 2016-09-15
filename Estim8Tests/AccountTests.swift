//
//  ControllerTests.swift
//  Estim8
//
//  Created by MigMit on 07/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import XCTest
import CoreData

class AccountTests: XCTestCase {
    
    var view: MocView? = nil
    
    override func setUp() {
        super.setUp()
        
        do {
            view = try setupTestCoreData(true)
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func createAccount(_ title: String, value: NSDecimalNumber, isNegative: Bool) {
        view?.mainWindow()?.tapPlusButton()
        view?.createAccount()?.title = title
        view?.createAccount()?.value = value
        view?.createAccount()?.isNegative = isNegative
        view?.createAccount()?.expectCurrency(nil)
        view?.createAccount()?.tapCurrency()
        view?.listCurrencies()?.tapCurrency(0)
        view?.createAccount()?.expectCurrency("$")
        view?.createAccount()?.tapOk()
    }
    
    func updateAccount(_ n: Int, value: NSDecimalNumber) {
        view?.mainWindow()?.tapAccount(n)
        view?.editAccount()?.value = value
        view?.editAccount()?.tapOk()
    }
    
    func deleteAccount(_ n: Int) {
        view?.mainWindow()?.tapAccount(n)
        view?.editAccount()?.tapDeleteButton()
    }
    
    func decant(_ from: Int, to: Int, amount: NSDecimalNumber) {
        view?.mainWindow()?.tapDecantButton()
        view?.decant()?.fromSelected = from
        view?.decant()?.toSelected = to
        view?.decant()?.value = amount
        view?.decant()?.useFromCurrency = true
        view?.decant()?.tapOk()
    }
    
    func testCreateAccount() {
        view?.mainWindow()?.expect([])
        createAccount("AAA", value: 1, isNegative: false)
        view?.mainWindow()?.expect([("AAA", 1)])
    }
    
    func testCancelCreating() {
        view?.mainWindow()?.expect([])
        view?.mainWindow()?.tapPlusButton()
        if let createAccount = view?.createAccount() {
            createAccount.tapCancel()
        }
        view?.mainWindow()?.expect([])
    }
    
    func testCreateTwoAccounts() {
        view?.mainWindow()?.expect([])
        createAccount("BBB", value: 2, isNegative: false)
        view?.mainWindow()?.expect([("BBB",2)])
        createAccount("CCC", value: -3, isNegative: true)
        view?.mainWindow()?.expect([("BBB",2),("CCC",-3)])
    }
    
    func testAddWrongAccount() {
        view?.mainWindow()?.expect([])
        view?.mainWindow()?.tapPlusButton()
        if let createAccount = view?.createAccount() {
            createAccount.title = "DDD"
            createAccount.value = 4
            createAccount.isNegative = true
            createAccount.tapOk()
            _ = view?.createAccount()
            createAccount.tapCancel()
        }
        view?.mainWindow()?.expect([])
        view?.mainWindow()?.tapPlusButton()
        if let createAccount = view?.createAccount() {
            createAccount.title = "EEE"
            createAccount.value = -5
            createAccount.isNegative = false
            createAccount.tapOk()
            _ = view?.createAccount()
            createAccount.tapCancel()
        }
        view?.mainWindow()?.expect([])
    }
    
    func testAddRightThenWrong() {
        view?.mainWindow()?.expect([])
        createAccount("FFF", value: 6, isNegative: false)
        view?.mainWindow()?.expect([("FFF", 6)])
        view?.mainWindow()?.tapPlusButton()
        if let createAccount = view?.createAccount() {
            createAccount.title = "GGG"
            createAccount.value = -7
            createAccount.isNegative = false
            createAccount.tapOk()
            _ = view?.createAccount()
            createAccount.tapCancel()
        }
        view?.mainWindow()?.expect([("FFF", 6)])
    }
    
    func testRemoveAccount() {
        view?.mainWindow()?.expect([])
        createAccount("NNN", value: 13, isNegative: false)
        view?.mainWindow()?.expect([("NNN", 13)])
        createAccount("OOO", value: 14, isNegative: false)
        view?.mainWindow()?.expect([("NNN", 13), ("OOO", 14)])
        deleteAccount(0)
        view?.mainWindow()?.expect([("OOO", 14)])
        createAccount("PPP", value: 15, isNegative: false)
        view?.mainWindow()?.expect([("OOO", 14), ("PPP", 15)])
        deleteAccount(1)
        view?.mainWindow()?.expect([("OOO", 14)])
    }
    
    func testStrikeOverAccount() {
        view?.mainWindow()?.expect([])
        createAccount("YYY", value: 25, isNegative: false)
        view?.mainWindow()?.expect([("YYY", 25)])
        view?.mainWindow()?.strikeOverAccount(0)
        view?.mainWindow()?.expect([])
    }
    
    func testNoSlices() {
        view?.mainWindow()?.expect([])
        createAccount("HHH", value: 7, isNegative: false)
        createAccount("III", value: 8, isNegative: false)
        view?.mainWindow()?.tapHistoryButton()
        if let slices = view?.slices() {
            slices.expect([("HHH", 7), ("III", 8)], buttonTitle: "Create", prevEnabled: false, nextEnabled: false)
            slices.tapCloseButton()
        }
        view?.mainWindow()?.expect([("HHH", 7), ("III", 8)])
    }
    
    func testAddSlice() {
        view?.mainWindow()?.expect([])
        createAccount("JJJ", value: 9, isNegative: false)
        createAccount("KKK", value: 10, isNegative: false)
        view?.mainWindow()?.tapHistoryButton()
        if let slices = view?.slices() {
            slices.expect([("JJJ", 9), ("KKK", 10)], buttonTitle: "Create", prevEnabled: false, nextEnabled: false)
            slices.tapCreateDeleteButton()
            slices.expect([("JJJ", 9), ("KKK", 10)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
            slices.tapPrevButton()
            slices.expect([("JJJ", 9), ("KKK", 10)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
        }
    }
    
    func testAddSliceUpdate() {
        view?.mainWindow()?.expect([])
        createAccount("LLL", value: 11, isNegative: false)
        createAccount("MMM", value: -12, isNegative: true)
        view?.mainWindow()?.tapHistoryButton()
        if let slices = view?.slices() {
            slices.expect([("LLL", 11), ("MMM", -12)], buttonTitle: "Create", prevEnabled: false, nextEnabled: false)
            slices.tapCreateDeleteButton()
            slices.expect([("LLL", 11), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
            slices.tapCloseButton()
        }
        updateAccount(0, value: 111)
        view?.mainWindow()?.expect([("LLL", 111), ("MMM", -12)])
        view?.mainWindow()?.tapHistoryButton()
        if let slices = view?.slices() {
            slices.expect([("LLL", 111), ("MMM", -12)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
            slices.tapNextButton()
            slices.expect([("LLL", 11), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
            slices.tapPrevButton()
            slices.expect([("LLL", 111), ("MMM", -12)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
            slices.tapCreateDeleteButton()
            slices.expect([("LLL", 111), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: true)
            slices.tapCloseButton()
        }
        updateAccount(1, value: -212)
        view?.mainWindow()?.expect([("LLL", 111), ("MMM", -212)])
        view?.mainWindow()?.tapHistoryButton()
        if let slices = view?.slices() {
            slices.expect([("LLL", 111), ("MMM", -212)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
            slices.tapNextButton()
            slices.expect([("LLL", 111), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: true)
            slices.tapNextButton()
            slices.expect([("LLL", 11), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
            slices.tapPrevButton()
            slices.expect([("LLL", 111), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: true)
            slices.slideTo(2)
            slices.expect([("LLL", 11), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
            slices.slideTo(0)
            slices.expect([("LLL", 111), ("MMM", -212)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
            slices.slideTo(1)
            slices.expect([("LLL", 111), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: true)
            slices.tapCreateDeleteButton()
            slices.expect([("LLL", 111), ("MMM", -212)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
            slices.tapNextButton()
            slices.expect([("LLL", 11), ("MMM", -12)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
        }
    }
    
    func testAddSliceRemove() {
        view?.mainWindow()?.expect([])
        createAccount("QQQ", value: 16, isNegative: false)
        view?.mainWindow()?.expect([("QQQ", 16)])
        view?.mainWindow()?.tapHistoryButton()
        view?.slices()?.expect([("QQQ", 16)], buttonTitle: "Create", prevEnabled: false, nextEnabled: false)
        view?.slices()?.tapCreateDeleteButton()
        view?.slices()?.expect([("QQQ", 16)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
        view?.slices()?.tapCloseButton()
        view?.mainWindow()?.expect([("QQQ", 16)])
        createAccount("RRR", value: 17, isNegative: false)
        view?.mainWindow()?.expect([("QQQ", 16), ("RRR", 17)])
        view?.mainWindow()?.tapHistoryButton()
        view?.slices()?.expect([("QQQ", 16), ("RRR", 17)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
        view?.slices()?.tapCreateDeleteButton()
        view?.slices()?.expect([("QQQ", 16), ("RRR", 17)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: true)
        view?.slices()?.tapCloseButton()
        createAccount("SSS", value: 18, isNegative: false)
        deleteAccount(1)
        view?.mainWindow()?.expect([("QQQ", 16), ("SSS", 18)])
        view?.mainWindow()?.tapHistoryButton()
        view?.slices()?.expect([("QQQ", 16), ("SSS", 18)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
        view?.slices()?.tapNextButton()
        view?.slices()?.expect([("QQQ", 16), nil, ("RRR", 17)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: true)
        view?.slices()?.tapNextButton()
        view?.slices()?.expect([("QQQ", 16), nil], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
    }
    
    func testDecant() {
        view?.mainWindow()?.expect([])
        createAccount("TTT", value: 0, isNegative: false)
        createAccount("UUU", value: 19, isNegative: false)
        createAccount("VVV", value: -20, isNegative: true)
        view?.mainWindow()?.expect([("TTT", 0), ("UUU", 19), ("VVV", -20)])
        decant(1, to: 0, amount: 19)
        view?.mainWindow()?.expect([("TTT", 19), ("UUU", 0), ("VVV", -20)])
        decant(0, to: 2, amount: 15)
        view?.mainWindow()?.expect([("TTT", 4), ("UUU", 0), ("VVV", -5)])
        decant(1, to: 2, amount: 0.1)
        view?.decant()?.tapCancel()
        view?.mainWindow()?.expect([("TTT", 4), ("UUU", 0), ("VVV", -5)])
        updateAccount(1, value: 10)
        view?.mainWindow()?.expect([("TTT", 4), ("UUU", 10), ("VVV", -5)])
        decant(1, to: 2, amount: 7)
        view?.decant()?.value = 5
        view?.decant()?.useFromCurrency = true
        view?.decant()?.tapOk()
        view?.mainWindow()?.expect([("TTT", 4), ("UUU", 5), ("VVV", 0)])
    }
    
    func testDecantSlice() {
        view?.mainWindow()?.expect([])
        createAccount("WWW", value: 10, isNegative: false)
        createAccount("XXX", value: -5, isNegative: true)
        view?.mainWindow()?.tapHistoryButton()
        view?.slices()?.expect([("WWW", 10), ("XXX", -5)], buttonTitle: "Create", prevEnabled: false, nextEnabled: false)
        view?.slices()?.tapCreateDeleteButton()
        view?.slices()?.expect([("WWW", 10), ("XXX", -5)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
        view?.slices()?.tapCloseButton()
        decant(0, to: 1, amount: 5)
        view?.mainWindow()?.expect([("WWW", 5), ("XXX", 0)])
        view?.mainWindow()?.tapHistoryButton()
        view?.slices()?.expect([("WWW", 5), ("XXX", 0)], buttonTitle: "Create", prevEnabled: false, nextEnabled: true)
        view?.slices()?.tapNextButton()
        view?.slices()?.expect([("WWW", 10), ("XXX", -5)], buttonTitle: "Delete", prevEnabled: true, nextEnabled: false)
    }
}
