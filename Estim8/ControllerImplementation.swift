//
//  Controller.swift
//  Estim8
//
//  Created by MigMit on 06/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerImplementation<Model: ModelInterface> {
    
    let model: Model
    
    let view: MainWindowView
    
    init(model: Model, view: MainWindowView) {
        self.model = model
        self.view = view
    }
}