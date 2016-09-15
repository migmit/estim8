//
//  UpdaterBackendECBImpl.swift
//  Estim8
//
//  Created by MigMit on 15/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class UpdaterBackendECBImpl: UpdaterBackendProtocol {
    
    let feedURL = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    
    func getExchangeRates() -> [String : (NSDecimalNumber, NSDecimalNumber)] {
        let delegate = UpdaterBackendECBDelegate()
        if
            let url = URL(string: feedURL),
            let parser = XMLParser(contentsOf: url)
        {
            parser.delegate = delegate
            parser.parse()
        }
        return delegate.result
    }
    
}

class UpdaterBackendECBDelegate: NSObject, XMLParserDelegate {
    
    var result: [String : (NSDecimalNumber, NSDecimalNumber)] = ["EUR" : (1,1)]
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "Cube") {
            if
                let currency = attributeDict["currency"],
                let rate = attributeDict["rate"]
            {
                let euroToThis = NSDecimalNumber(string: rate, locale: [NSLocale.Key.decimalSeparator : "."])
                result[currency] = (NSDecimalNumber.one.dividing(by: euroToThis), euroToThis)
            }
        }
    }
    
}
