//
//  CreateAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class CreateAccountImplementation: CreateAccountView {
    
    let controller: ControllerCreateAccountInterface
    
    let parent: ViewController
    
    weak var view: CreateAccountViewController? = nil
    
    init(controller: ControllerCreateAccountInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: CreateAccountViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("CreateAccount", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
}

class CreateAccountViewController: SubViewController {

    var viewImplementation: CreateAccountImplementation? = nil
    
    @IBOutlet weak var accountTitleText: UITextField!
    
    @IBOutlet weak var accountValueText: NumberField!
    
    @IBOutlet weak var positiveCell: UITableViewCell!
    
    @IBOutlet weak var negativeCell: UITableViewCell!
    
    var isNegative: Bool = false
    
    func setViewImplementation(viewImplementation: CreateAccountImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(buttonSaveClicked))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(notificationTitleChanged), name: UITextFieldTextDidChangeNotification, object: accountTitleText)
        center.addObserver(self, selector: #selector(notificationValueChanged), name: UITextFieldTextDidChangeNotification, object: accountValueText)
        somethingChanged()
        accountTitleText.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                accountTitleText.becomeFirstResponder()
            case 1:
                accountValueText.becomeFirstResponder()
            default:
                break
            }
        case 1:
            if (indexPath.row == 1) {
                isNegative = true
                positiveCell.accessoryType = .None
                negativeCell.accessoryType = .Checkmark
                accountValueText.setIsNegative(true)
                somethingChanged()
            } else {
                isNegative = false
                positiveCell.accessoryType = .Checkmark
                negativeCell.accessoryType = .None
                accountValueText.setIsNegative(false)
                somethingChanged()
            }
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func buttonSaveClicked() {
        accountValueText.resignFirstResponder()
        let title = accountTitleText.text ?? ""
        let value = accountValueText.getValue()
        if let controller = viewImplementation?.controller, let currency = controller.currencies().currency(0) {
            if (!(controller.create(title, initialValue: value, currency: currency, isNegative: isNegative) ?? false)) {
                let alert = UIAlertController(title: "Error", message: "Can't create \(isNegative ? "negative" : "positive") account \"\(title)\" with value \(value)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func somethingChanged() {
        let title = accountTitleText.text ?? ""
        let value = accountValueText.getValue()
        if let controller = viewImplementation?.controller, let currency = controller.currencies().currency(0) {
            navigationItem.rightBarButtonItem?.enabled = controller.canCreate(title, initialValue: value, currency: currency, isNegative: isNegative)
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    func notificationTitleChanged(notification: NSNotification) {
        somethingChanged()
    }
    
    func notificationValueChanged(notification: NSNotification) {
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
