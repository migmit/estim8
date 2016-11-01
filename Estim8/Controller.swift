//
//  Controller.swift
//  Estim8
//
//  Created by MigMit on 30/10/2016.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class Controller<Response> {
    
    var responseFunction: ((Response) -> ())? = nil
    
    func setResponseFunction(_ responseFunction: @escaping (Response) -> ()) -> Self {
        self.responseFunction = responseFunction
        return self
    }
    
    func respond(_ response: Response) {
        responseFunction?(response)
    }

}
