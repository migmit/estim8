//
//  EditCurrencyViewController.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class EditCurrencyImplementation: EditCurrencyView {
    
    let controller: ControllerEditCurrencyInterface
    
    let parent: ListCurrenciesViewController
    
    weak var view: EditCurrencyViewController? = nil
    
    init(controller: ControllerEditCurrencyInterface, parent: ListCurrenciesViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(_ view: EditCurrencyViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegue(withIdentifier: "EditCurrency", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func selectRelative(_ controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView {
        return SelectCurrencyImplementation(controller: controller, parent: view!)
    }
    
    func relativeSelected(_ selected: ControllerROCurrencyInterface?) {
        //TODO
    }
}

class EditCurrencyViewController: SubViewController, SelectCurrencyViewControllerInterface {
    
    var viewImplementation: EditCurrencyImplementation? = nil
    
    func setViewImplementation(_ viewImplementation: EditCurrencyImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    func showSelectCurrencyView(_ sender: SelectCurrencyView) {
        performSegue(withIdentifier: "SelectCurrency", sender: sender)
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
