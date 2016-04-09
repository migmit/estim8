//
//  EditAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class EditAccountImplementation: EditAccountView {
    
    let controller: ControllerEditAccountInterface
    
    let parent: ViewController
    
    var view: EditAccountViewController? = nil
    
    init(controller: ControllerEditAccountInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: EditAccountViewController) {
        self.view = view
        view.setController(controller)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("EditAccount", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
}

class EditAccountViewController: SubViewController {
    
    var controller: ControllerEditAccountInterface? = nil
    
    func setController(controller: ControllerEditAccountInterface) {
        self.controller = controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(buttonSaveClicked))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonSaveClicked() {
        //
        navigationController?.popViewControllerAnimated(true)
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
