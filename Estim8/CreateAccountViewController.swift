//
//  CreateAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class CreateAccountImplementation: CreateAccountView {
    
    let controller: ControllerCreateAccountInterface
    
    let parent: ViewController
    
    var view: CreateAccountViewController? = nil
    
    init(controller: ControllerCreateAccountInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: CreateAccountViewController) {
        self.view = view
        view.setController(controller)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("CreateAccount", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
}

class CreateAccountViewController: SubViewController {

    var controller: ControllerCreateAccountInterface? = nil
    
    func setController(controller: ControllerCreateAccountInterface) {
        self.controller = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
