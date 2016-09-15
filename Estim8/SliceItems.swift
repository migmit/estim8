//
//  SliceItems.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol ControllerSliceInterface {
    
    func sliceIndex() -> Int
    
    func buttonCalledCreate() -> Bool
    
    func numberOfAccounts() -> Int
    
    func account(_ n: Int) -> ControllerTransitionAccountInterface?
    
    func whereToMove(_ account: ControllerTransitionInterface) -> (Int, Bool)?
    
    func next() -> ControllerSliceInterface?
    
    func prev() -> ControllerSliceInterface?
    
    func createOrRemove()
    
    func sliceDate() -> Date?
}
