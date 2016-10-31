//
//  Controller.swift
//  Estim8
//
//  Created by MigMit on 30/10/2016.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class Holder<T> {
    let t: T
    init(_ t: T) {self.t = t}
}

protocol ControllerProtocol {
    associatedtype CPResponse
    associatedtype CPView
    func setResponseFunction(responseFunction: @escaping (CPResponse) -> ())
    func setView(_ view: CPView)
}

class Controller<Response, View>: ControllerProtocol {
    
    typealias CPResponse = Response
    typealias CPView = View
    
    var responseFunction: ((Response) -> ())? = nil
    
    weak var viewHolder: Holder<View>? = nil
    
    var view: View? {
        get {
            return viewHolder?.t
        }
    }
    
    func setResponseFunction(responseFunction: @escaping (Response) -> ()) {
        self.responseFunction = responseFunction
    }
    
    func respond(_ response: Response) {
        responseFunction?(response)
    }
    
    func setView(_ view: View) {
        self.viewHolder = Holder(view)
    }

}
