//
//  Setup.swift
//  Estim8
//
//  Created by MigMit on 12/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import CoreData

func setupTestCoreData() throws -> MocView? {
    if
        let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil),
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
    {
        try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        let currency: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: context)
        let currencyUpdate = NSEntityDescription.insertNewObjectForEntityForName("CurrencyUpdate", inManagedObjectContext: context)
        currency.setValue("USD", forKey: "code")
        currency.setValue("United States Dollar", forKey: "name")
        currency.setValue("$", forKey: "symbol")
        currency.setValue(0, forKey: "sortingIndex")
        currency.setValue(NSDate(), forKey: "addDate")
        currency.setValue(false, forKey: "removed")
        currency.setValue(Set<NSManagedObject>(), forKey: "updates")
        currency.setValue(Set<NSManagedObject>(), forKey: "based")
        currencyUpdate.setValue(NSDate(), forKey: "date")
        currencyUpdate.setValue(1, forKey: "rate")
        currencyUpdate.setValue(1, forKey: "inverseRate")
        currencyUpdate.setValue(true, forKey: "manual")
        currencyUpdate.setValue(currency, forKey: "base")
        currencyUpdate.setValue(currency, forKey: "currency")
        currencyUpdate.setValue(Set<NSManagedObject>(), forKey: "updates")
        
        do {try context.save()} catch {}
        
        let model = ModelImplementation(managedObjectContext: context)
        let controller = ControllerImplementation(model: model)
        let mainWindowView = MainWindowMoc(controller: controller)
        controller.setView(mainWindowView)
        let view = MocView(mainWindow: mainWindowView)
        mainWindowView.setView(view)
        return view
    } else {
        return nil
    }
}
