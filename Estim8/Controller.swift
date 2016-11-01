//
//  Controller.swift
//  Estim8
//
//  Created by MigMit on 30/10/2016.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerProtocol {
    associatedtype CPResponse
    func setResponseFunction(_ responseFunction: @escaping (CPResponse) -> ())
}

class Controller<Response>: ControllerProtocol {
    
    typealias CPResponse = Response
    var responseFunction: ((Response) -> ())? = nil
    
    func setResponseFunction(_ responseFunction: @escaping (Response) -> ()) {
        self.responseFunction = responseFunction
    }
    
    func respond(_ response: Response) {
        responseFunction?(response)
    }

}
