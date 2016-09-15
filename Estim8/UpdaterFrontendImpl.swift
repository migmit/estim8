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
    
    let updateInterval: TimeInterval
    
    let sinceLastUpdate: TimeInterval
    
    let lastUpdateKey = "updater.lastUpdate"
    
    var timer: Timer?
    
    init(model: Model, updateInterval: TimeInterval, sinceLastUpdate: TimeInterval, backend: UpdaterBackendProtocol) { // updateInterval > sinceLastUpdate
        self.model = model
        self.backend = backend
        self.updateInterval = updateInterval
        self.sinceLastUpdate = sinceLastUpdate
    }
    
    @objc func startUpdating() {
        let defaults = UserDefaults.standard
        let lastUpdateDate = defaults.object(forKey: lastUpdateKey) as? Date
        let updatePossible = lastUpdateDate.map{$0.addingTimeInterval(sinceLastUpdate).compare(Date()) == .orderedAscending} ?? true
        if (updatePossible) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                let exchangeRates = self.backend.getExchangeRates()
                DispatchQueue.main.async {
                    let currencies = self.model.liveCurrencies()
                    for c in currencies {
                        if
                            let code = self.model.codeOfCurrency(c),
                            let rate = exchangeRates[code]
                        {
                            self.model.updateCurrency(c, base: nil, rate: rate.0, invRate: rate.1, manual: false)
                        }
                    }
                    defaults.set(Date(), forKey: self.lastUpdateKey)
                    self.setTimer()
                }
            }
        } else {
            setTimer()
        }
    }
    
    func setTimer() {
        let timer = Timer(fireAt: Date().addingTimeInterval(updateInterval), interval: 0, target: self, selector: #selector(startUpdating), userInfo: nil, repeats: false)
        self.timer = timer
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func stopUpdating() {
        if let t = timer {
            t.invalidate()
        }
    }
    
}
