//
//  ProductionController.swift
//  Estim8
//
//  Created by MigMit on 13/11/2016.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObjectContext = appDelegate.managedObjectContext
let model = ModelImplementation(managedObjectContext: managedObjectContext)

let controllers: Controllers = ControllersImpl(model: model)

let updateInterval: TimeInterval = 24*60*60
let sinceLastUpdate: TimeInterval = 12*60*60
func startUpdate() -> UpdaterFrontend {
    let updater = UpdaterFrontendImpl(model: model, updateInterval: updateInterval, sinceLastUpdate: sinceLastUpdate, backend: UpdaterBackendECBImpl())
    updater.startUpdating()
    return updater
}
let updater = startUpdate()
