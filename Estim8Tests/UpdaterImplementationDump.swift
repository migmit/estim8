//
//  UpdaterImplementationDump.swift
//  Estim8
//
//  Created by MigMit on 15/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import XCTest

class UpdaterImplementationDump: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDump() {
        let updater = UpdaterBackendECBImpl()
        let dict = updater.getExchangeRates()
        XCTAssertNotNil(dict["EUR"])
        if let rate = dict["EUR"] {
            XCTAssertEqual(rate.0, 1)
            XCTAssertEqual(rate.1, 1)
        }
        XCTAssertNotNil(dict["USD"])
        if let rate = dict["USD"] {
            XCTAssertEqual(rate.0, NSDecimalNumber.one.dividing(by: rate.1))
        }
    }

}
