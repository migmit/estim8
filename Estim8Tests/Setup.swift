//
//  Setup.swift
//  Estim8
//
//  Created by MigMit on 12/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import CoreData

func setupTestCoreData(_ createCurrency: Bool) throws -> MocView? {
    if let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil) {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        do {try context.save()} catch {}
        
        let model = ModelImplementation(managedObjectContext: context)
        
        if (createCurrency) {
            _ = model.addCurrencyAndUpdate("$", code: "USD", symbol: "$", base: nil, rate: 1, invRate: 1, manual: false)
        }
        
        let controller = ControllerImplementation(model: model)
        let mainWindowView = MainWindowMoc(controller: controller)
        let view = MocView(mainWindow: mainWindowView)
        mainWindowView.setView(view)
        return view
    } else {
        return nil
    }
}
