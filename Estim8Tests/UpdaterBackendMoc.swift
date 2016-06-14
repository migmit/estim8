//
//  UpdaterBackendMoc.swift
//  Estim8
//
//  Created by MigMit on 14/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class UpdaterBackendMoc: UpdaterBackendProtocol {
    
    var exchangeRates: [String: (NSDecimalNumber, NSDecimalNumber)] = [:]
    
    func getExchangeRates() -> [String : (NSDecimalNumber, NSDecimalNumber)] {
        return exchangeRates
    }
    
}