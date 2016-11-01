//
//  EditAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class EditAccountViewController: SubViewController {
    
    var controller: ControllerEditAccountInterface? = nil
    
    @IBOutlet weak var accountNameLabel: UILabel!
    
    @IBOutlet weak var accountValueText: NumberField!

    func setController(_ controller: ControllerEditAccountInterface) {
        self.controller = controller
    }
    
    func showListCurrenciesView(_ sender: ControllerListCurrenciesInterface) {
        performSegue(withIdentifier: "ListCurrencies", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonSaveClicked))
        if let c = controller {
            accountNameLabel.text = c.name()
            accountValueText.setValue(c.value(), isNegative: c.isNegative())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(notificationValueChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: accountValueText)
        somethingChanged()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).section {
        case 0:
            accountValueText.becomeFirstResponder()
        default:
            break;
        }
    }
    
    @IBAction func buttonDeleteClicked(_ sender: UIButton) {
        if let c = controller {
            let alert = UIAlertController(title: c.name() , message: "Delete?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                if (c.act(.Remove)) {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func buttonSaveClicked() {
        let value = accountValueText.getValue()
        if let c = controller{
            if (c.act(.SetValue(value))) {
                _ = navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Can't set the value of \(c.name()) to \(value)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func somethingChanged() {
        let value = accountValueText.getValue()
        if let c = controller {
            navigationItem.rightBarButtonItem?.isEnabled = c.canSetValue(value)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func notificationValueChanged(_ notification: Notification) {
        somethingChanged()
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
