//
//  CreateCurrencyViewController.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class CreateCurrencyImplementation: CreateCurrencyView {
    
    init() {
        
    }
    
    func showSubView() {
        //TODO
    }
    
    func hideSubView() {
        //TODO
    }
    
    func selectRelative(controller: ControllerSelectCurrencyInterface) -> SelectCurrencyView {
        //TODO
        return SelectCurrencyImplementation()
    }
    
}

class CreateCurrencyViewController: SubViewController {

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
