//
//  Controllers.swift
//  Estim8
//
//  Created by MigMit on 13/11/2016.
//  Copyright © 2016 MigMit. All rights reserved.
//

import Foundation

protocol Controllers {
    func accounts() -> ControllerAccountsInterface
    func slices() -> ControllerSlicesInterface
}
