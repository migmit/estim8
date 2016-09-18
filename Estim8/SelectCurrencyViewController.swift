//
//  SelectCurrencyViewController.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class SelectCurrencyImplementation: SelectCurrencyView {
    
    let controller: ControllerSelectCurrencyInterface
    
    let parent: SelectCurrencyViewControllerInterface
    
    weak var view: SelectCurrencyViewController? = nil
    
    init(controller: ControllerSelectCurrencyInterface, parent: SelectCurrencyViewControllerInterface) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(_ view: SelectCurrencyViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.showSelectCurrencyView(self)
    }
    
    func hideSubView() {
        _ = view?.navigationController?.popViewController(animated: true)
    }
    
}

class SelectCurrencyViewController: SubViewController {
    
    var viewImplementation: SelectCurrencyImplementation? = nil
    
    func setViewImplementation(_ viewImplementation: SelectCurrencyImplementation) {
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
