//
//  CreateCurrencyViewController.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class CreateCurrencyImplementation: CreateCurrencyView {
    
    let controller: ControllerCreateCurrencyInterface
    
    let parent: ListCurrenciesViewController
    
    weak var view: CreateCurrencyViewController? = nil
    
    init(controller: ControllerCreateCurrencyInterface, parent: ListCurrenciesViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: CreateCurrencyViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("CreateCurrency", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
    
    func selectRelative(controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView {
        return SelectCurrencyImplementation(controller: controller, parent: view!)
    }
    
    func relativeSelected(selected: ControllerROCurrencyInterface) {
        //TODO
    }
    
}

class CreateCurrencyViewController: SubViewController, SelectCurrencyViewControllerInterface {

    var viewImplementation: CreateCurrencyImplementation? = nil

    func setViewImplementation(viewImplementation: CreateCurrencyImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    func showSelectCurrencyView(sender: SelectCurrencyView) {
        performSegueWithIdentifier("SelectCurrency", sender: sender)
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
