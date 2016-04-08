//
//  ControllerTests.swift
//  Estim8
//
//  Created by MigMit on 07/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import XCTest
import CoreData

class ControllerTests: XCTestCase {
    
    var view: MocView? = nil
    
    override func setUp() {
        super.setUp()

        do {
            if let objectModel: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles()){
                if let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel){
                    try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
                    let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                    context.persistentStoreCoordinator = coordinator
                    
                    let model = ModelImplementation(managedObjectContext: context)
                    let controller = ControllerImplementation(model: model)
                    let mainWindowView = MainWindowMoc(controller: controller)
                    controller.setView(mainWindowView)
                    view = MocView(mainWindow: mainWindowView)
                }
            }
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        
}
