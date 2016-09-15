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
    
    func setView(_ view: ListCurrenciesViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.showListCurrenciesView(self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func createCurrency(_ controller: ControllerCreateCurrencyInterface) -> CreateCurrencyView {
        return CreateCurrencyImplementation(controller: controller, parent: view!)
    }
    
    func editCurrency(_ controller: ControllerEditCurrencyInterface) -> EditCurrencyView {
        return EditCurrencyImplementation(controller: controller, parent: view!)
    }
    
    func refreshCurrency(_ n: Int) {
        //TODO
    }
    
    func removeCurrency(_ n: Int) {
        //TODO
    }
    
    func addCurrency() {
        //TODO
    }
    
}

class ListCurrenciesViewController: SubViewController {
    
    var viewImplementation: ListCurrenciesView? = nil
    
    func setViewImplementation(_ viewImplementation: ListCurrenciesImplementation) {
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
