//
//  ListCurrenciesViewController.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class ListCurrenciesImplementation: ListCurrenciesView {
    
    let controller: ControllerListCurrenciesInterface
    
    let parent: ListCurrenciesViewControllerInterface
    
    weak var view: ListCurrenciesViewController? = nil
    
    init(controller: ControllerListCurrenciesInterface, parent: ListCurrenciesViewControllerInterface) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: ListCurrenciesViewController) {
        self.view = view
        view.setViewImplementation(self)
    }

    func showSubView() {
        parent.showListCurrenciesView(self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
    
    func createCurrency(controller: ControllerCreateCurrencyInterface) -> CreateCurrencyView {
        return CreateCurrencyImplementation(controller: controller, parent: view!)
    }
    
    func editCurrency(controller: ControllerEditCurrencyInterface) -> EditCurrencyView {
        return EditCurrencyImplementation(controller: controller, parent: view!)
    }
    
    func refreshCurrency(n: Int) {
        //TODO
    }
    
    func removeCurrency(n: Int) {
        //TODO
    }
    
    func addCurrency() {
        //TODO
    }
    
}

class ListCurrenciesViewController: SubViewController {
    
    var viewImplementation: ListCurrenciesView? = nil
    
    func setViewImplementation(viewImplementation: ListCurrenciesImplementation) {
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
