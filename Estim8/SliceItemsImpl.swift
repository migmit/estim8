//
//  SliceItemsImpl.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

class ControllerCurrentStatePseudoSliceImplementation<Model: ModelInterface>: ControllerSliceInterface {
    
    let parent: ControllerSlicesImplementation<Model>
    
    let model: Model
    
    let liveAccounts: [Model.Account]
    
    let numbers: [Model.Account: (Int, Bool)]
    
    init(parent: ControllerSlicesImplementation<Model>, model: Model) {
        self.parent = parent
        self.model = model
        let liveAccounts = model.liveAccounts()
        self.liveAccounts = liveAccounts
        var numbers: [Model.Account: (Int, Bool)] = [:]
        var i: Int = 0
        for account in liveAccounts {
            numbers.updateValue((i, true), forKey: account)
            i += 1
        }
        for account in model.deadAccounts() {
            numbers.updateValue((i, false), forKey: account)
        }
        self.numbers = numbers
    }
    
    func sliceIndex() -> Int {
        return 0
    }
    
    func buttonCalledCreate() -> Bool {
        return true
    }
    
    func numberOfAccounts() -> Int {
        return liveAccounts.count
    }
    
    func account(_ n: Int) -> ControllerTransitionAccountInterface? {
        if (n >= liveAccounts.count) {
            return nil
        } else {
            return ControllerTransitionAccountImplementation(model: model, account: liveAccounts[n])
        }
    }
    
    func whereToMove(_ account: ControllerTransitionInterface) -> (Int, Bool)? {
        if let t = account as? ControllerTransitionImplementation<Model> {
            return numbers[t.account]
        } else {
            return nil
        }
    }
    
    func next() -> ControllerSliceInterface? {
        let slices = model.slices()
        if (slices.isEmpty) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: parent, model: model, slice: slices[0], index: 0)
        }
    }
    
    func prev() -> ControllerSliceInterface? {
        return nil
    }
    
    func createOrRemove() {
        let slice = model.createSlice()
        parent.createSlice(ControllerSliceImplementation(parent: parent, model: model, slice: slice, index: 0))
    }
    
    func sliceDate() -> Date? {
        return nil
    }
}

class ControllerSliceImplementation<Model: ModelInterface>: ControllerSliceInterface {
    
    let parent: ControllerSlicesImplementation<Model>
    
    let model: Model
    
    let slice: Model.Slice
    
    let index: Int
    
    let updates: [Model.Update?]
    
    let numbers: [Model.Account: (Int, Bool)]
    
    init(parent: ControllerSlicesImplementation<Model>, model: Model, slice: Model.Slice, index: Int) {
        self.parent = parent
        self.model = model
        self.slice = slice
        self.index = index
        let lastUpdates = model.lastUpdatesOfSlice(slice)
        var updateAccounts: [Model.Account: Model.Update] = [:]
        for update in lastUpdates {
            updateAccounts.updateValue(update, forKey: model.accountOfUpdate(update))
        }
        var updates: [Model.Update?] = []
        var i = 0
        var numbers: [Model.Account: (Int, Bool)] = [:]
        for account in model.liveAccounts() {
            updates.append(updateAccounts[account])
            numbers.updateValue((i, true), forKey: account)
            i += 1
        }
        for account in model.deadAccounts() {
            if let update = updateAccounts[account] {
                updates.append(update)
                numbers.updateValue((i, true), forKey: account)
                i += 1
            } else {
                numbers.updateValue((i, false), forKey: account)
            }
        }
        self.updates = updates
        self.numbers = numbers
    }
    
    func sliceIndex() -> Int {
        return index + 1
    }
    
    func buttonCalledCreate() -> Bool {
        return false
    }
    
    func numberOfAccounts() -> Int {
        return updates.count
    }
    
    func account(_ n: Int) -> ControllerTransitionAccountInterface? {
        if (n >= updates.count) {
            return nil
        } else {
            if let update = updates[n] {
                return ControllerUpdateInterface(model: model, update: update)
            } else {
                return nil
            }
        }
    }
    
    func whereToMove(_ account: ControllerTransitionInterface) -> (Int, Bool)? {
        if let t = account as? ControllerTransitionImplementation<Model> {
            return numbers[t.account]
        } else {
            return nil
        }
    }
    
    func next() -> ControllerSliceInterface? {
        let slices = model.slices()
        let n = index + 1
        if (n >= slices.count) {
            return nil
        } else {
            return ControllerSliceImplementation(parent: parent, model: model, slice: slices[n], index: n)
        }
    }
    
    func prev() -> ControllerSliceInterface? {
        if (index == 0) {
            return ControllerCurrentStatePseudoSliceImplementation(parent: parent, model: model)
        } else {
            let slices = model.slices()
            let n = index - 1
            return ControllerSliceImplementation(parent: parent, model: model, slice: slices[n], index: n)
        }
    }
    
    func createOrRemove() {
        let newSlice = prev()!
        model.removeSlice(slice)
        parent.removeSlice(newSlice)
    }
    
    func sliceDate() -> Date? {
        return model.dateOfSlice(slice)
    }
}
