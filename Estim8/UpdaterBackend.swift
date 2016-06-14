//
//  UpdaterBackend.swift
//  Estim8
//
//  Created by MigMit on 14/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol UpdaterBackendProtocol {
    
    func getExchangeRates() -> [String : (NSDecimalNumber, NSDecimalNumber)]
    
}