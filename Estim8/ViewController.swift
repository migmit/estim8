//
//  ViewController.swift
//  Estim8
//
//  Created by MigMit on 02/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class MainWindowImplementation: MainWindowView {
    
    func createAccount(controller: ControllerCreateAccountInterface) -> CreateAccountView {
        //
        return CreateAccountImplementation()
    }
    
    func decant(controller: ControllerDecantInterface) -> DecantView {
        //
        return DecantImplementation()
    }
    
    func showSlices(controller: ControllerSlicesInterface) -> SlicesView {
        //
        return SlicesImplementation()
    }
    
    func editAccount(controller: ControllerEditAccountInterface) -> EditAccountView {
        //
        return EditAccountImplementation()
    }
    
    func refreshAccount(n: Int) {
        //
    }
    
    func removeAccount(n: Int) {
        //
    }
    
    func addAccount() {
        //
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

