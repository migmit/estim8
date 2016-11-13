//
//  File.swift
//  Estim8
//
//  Created by MigMit on 13/11/2016.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllersImpl<Model: ModelInterface>: Controllers {
    
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    func accounts() -> ControllerAccountsInterface {
        return ControllerAccountsImplementation(model: model)
    }
    
    func slices() -> ControllerSlicesInterface {
        return ControllerSlicesImplementation(model: model)
    }
}
