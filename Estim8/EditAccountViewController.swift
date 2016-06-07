//
//  EditAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class EditAccountImplementation: EditAccountView {
    
    let controller: ControllerEditAccountInterface
    
    let parent: ViewController
    
    weak var view: EditAccountViewController? = nil
    
    init(controller: ControllerEditAccountInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: EditAccountViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("EditAccount", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
    
    func selectCurrency(controller: ControllerListCurrenciesInterface) -> ListCurrenciesView {
        return ListCurrenciesImplementation(controller: controller, parent: view!)
    }
    
    func currencySelected(selected: ControllerROCurrencyInterface) {
        //TODO
    }
}

class EditAccountViewController: SubViewController, ListCurrenciesViewControllerInterface {
    
    var viewImplementation: EditAccountImplementation? = nil
    
    var currency: ControllerROCurrencyInterface? = nil
    
    @IBOutlet weak var accountNameLabel: UILabel!

    @IBOutlet weak var accountValueText: NumberField!
    
    func setViewImplementation(viewImplementation: EditAccountImplementation) {
        self.viewImplementation = viewImplementation
        self.currency = viewImplementation.controller.currency()
    }
    
    func showListCurrenciesView(sender: ListCurrenciesView) {
        performSegueWithIdentifier("ListCurrencies", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(buttonSaveClicked))
        if let controller = self.viewImplementation?.controller {
            accountNameLabel.text = controller.name()
            accountValueText.setValue(controller.value(), isNegative: controller.isNegative())
        }
    }

    override func viewWillAppear(animated: Bool) {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(notificationValueChanged), name: UITextFieldTextDidChangeNotification, object: accountValueText)
        somethingChanged()
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            accountValueText.becomeFirstResponder()
        default:
            break;
        }
    }

    @IBAction func buttonDeleteClicked(sender: UIButton) {
        if let controller = viewImplementation?.controller {
            let alert = UIAlertController(title: controller.name() ?? "", message: "Delete?", preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: {_ in controller.remove()}))
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func buttonSaveClicked() {
        let value = accountValueText.getValue()
        if let controller = viewImplementation?.controller, let c = currency {
            if (!(controller.setValue(value, currency: c) ?? false)) {
                let alert = UIAlertController(title: "Error", message: "Can't set the value of \(controller.name() ?? "the account") to \(value)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    func somethingChanged() {
        let value = accountValueText.getValue()
        if let controller = viewImplementation?.controller, let c = currency {
            navigationItem.rightBarButtonItem?.enabled = controller.canSetValue(value, currency: c)
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
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
