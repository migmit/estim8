//
//  CreateAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class CreateAccountViewController: SubViewController, ListCurrenciesViewControllerInterface {
    
    var controller: ControllerCreateAccountInterface? = nil
    
    @IBOutlet weak var accountTitleText: UITextField!
    
    @IBOutlet weak var accountValueText: NumberField!
    
    @IBOutlet weak var positiveCell: UITableViewCell!
    
    @IBOutlet weak var negativeCell: UITableViewCell!
    
    var isNegative: Bool = false
    
    func showListCurrenciesView(_ sender: ControllerListCurrenciesInterface) {
        performSegue(withIdentifier: "ListCurrencies", sender: sender)
    }
    
    func setController(_ controller: ControllerCreateAccountInterface) {
        self.controller = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonSaveClicked))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(notificationTitleChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: accountTitleText)
        center.addObserver(self, selector: #selector(notificationValueChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: accountValueText)
        somethingChanged()
        accountTitleText.becomeFirstResponder()
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
        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).row {
            case 0:
                accountTitleText.becomeFirstResponder()
            case 1:
                accountValueText.becomeFirstResponder()
            default:
                break
            }
        case 1:
            if ((indexPath as NSIndexPath).row == 1) {
                isNegative = true
                positiveCell.accessoryType = .none
                negativeCell.accessoryType = .checkmark
                accountValueText.setIsNegative(true)
                somethingChanged()
            } else {
                isNegative = false
                positiveCell.accessoryType = .checkmark
                negativeCell.accessoryType = .none
                accountValueText.setIsNegative(false)
                somethingChanged()
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func buttonSaveClicked() {
        accountValueText.resignFirstResponder()
        let title = accountTitleText.text ?? ""
        let value = accountValueText.getValue()
        if let c = controller {
            if (c.create(title, initialValue: value, isNegative: isNegative)) {
                _ = navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Can't create \(isNegative ? "negative" : "positive") account \"\(title)\" with value \(value)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func somethingChanged() {
        let title = accountTitleText.text ?? ""
        let value = accountValueText.getValue()
        if let c = controller {
            navigationItem.rightBarButtonItem?.isEnabled = c.canCreate(title, initialValue: value, isNegative: isNegative)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func notificationTitleChanged(_ notification: Notification) {
        somethingChanged()
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
