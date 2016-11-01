//
//  EditCurrencyViewController.swift
//  Estim8
//
//  Created by MigMit on 06/06/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class EditCurrencyViewController: SubViewController {
    
    //        _ = view?.navigationController?.popViewController(animated: true)
    
    var controller: ControllerEditCurrencyInterface? = nil
    
    func setController(_ controller: ControllerEditCurrencyInterface) {
        self.controller = controller
    }
        
    func showSelectCurrencyView(_ sender: ControllerSelectCurrencyInterface) {
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
