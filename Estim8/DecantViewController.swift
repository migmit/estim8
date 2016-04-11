//
//  DecantViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class DecantImplementation: DecantView {
    
    let controller: ControllerDecantInterface
    
    let parent: ViewController
    
    weak var view: DecantViewController? = nil
    
    init(controller: ControllerDecantInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: DecantViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("Decant", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
}

class DecantViewController: SubViewController {

    var viewImplementation: DecantImplementation? = nil
    
    func setViewImplementation(viewImplementation: DecantImplementation) {
        self.viewImplementation = viewImplementation
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
