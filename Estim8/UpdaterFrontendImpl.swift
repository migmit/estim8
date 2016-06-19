//
//  UpdaterFrontend.swift
//  Estim8
//
//  Created by MigMit on 17/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation
import CoreData

class UpdaterFrontendImpl<Model: ModelInterface>: UpdaterFrontend {
    
    let backend: UpdaterBackendProtocol
    
    let model: Model
    
    let updateInterval: NSTimeInterval
    
    let sinceLastUpdate: NSTimeInterval
    
    let lastUpdateKey = "updater.lastUpdate"
    
    var timer: NSTimer?
    
    init(model: Model, updateInterval: NSTimeInterval, sinceLastUpdate: NSTimeInterval, backend: UpdaterBackendProtocol) { // updateInterval > sinceLastUpdate
        self.model = model
        self.backend = backend
        self.updateInterval = updateInterval
        self.sinceLastUpdate = sinceLastUpdate
    }
    
    @objc func startUpdating() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastUpdateDate = defaults.objectForKey(lastUpdateKey) as? NSDate
        let updatePossible = lastUpdateDate.map{$0.dateByAddingTimeInterval(sinceLastUpdate).compare(NSDate()) == .OrderedAscending} ?? true
        if (updatePossible) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                let exchangeRates = self.backend.getExchangeRates()
                dispatch_async(dispatch_get_main_queue()) {
                    let currencies = self.model.liveCurrencies()
                    for c in currencies {
                        if
                            let code = self.model.codeOfCurrency(c),
                            let rate = exchangeRates[code]
                        {
                            self.model.updateCurrency(c, base: nil, rate: rate.0, invRate: rate.1, manual: false)
                        }
                    }
                    defaults.setObject(NSDate(), forKey: self.lastUpdateKey)
                    self.setTimer()
                }
            }
        } else {
            setTimer()
        }
    }
    
    func setTimer() {
        let timer = NSTimer(fireDate: NSDate().dateByAddingTimeInterval(updateInterval), interval: 0, target: self, selector: #selector(startUpdating), userInfo: nil, repeats: false)
        self.timer = timer
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    func stopUpdating() {
        if let t = timer {
            t.invalidate()
        }
    }
    
}