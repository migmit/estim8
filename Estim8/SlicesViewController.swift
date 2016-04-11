//
//  SlicesViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class SlicesImplementation: SlicesView {
    
    let controller: ControllerSlicesInterface
    
    let parent: ViewController
    
    weak var view: SlicesViewController? = nil
    
    init(controller: ControllerSlicesInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: SlicesViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("Slices", sender: self)
    }
    
    func hideSubView() {
        view?.dismissViewControllerAnimated(true, completion: nil)
    }

    func createSlice() {
        
    }
    
    func removeSlice() {
        
    }
}

class SlicesViewController: UIViewController {

    var viewImplementation: SlicesImplementation? = nil
    
    func setViewImplementation(viewImplementation: SlicesImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTempClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
