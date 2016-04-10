//
//  ViewController.swift
//  Estim8
//
//  Created by MigMit on 02/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class MainWindowImplementation: MainWindowView {
    
    let controller: ControllerInterface
    
    let view: ViewController
    
    init(controller: ControllerInterface, view: ViewController) {
        self.controller = controller
        self.view = view
    }
    
    func createAccount(controller: ControllerCreateAccountInterface) -> CreateAccountView {
        return CreateAccountImplementation(controller: controller, parent: view)
    }
    
    func decant(controller: ControllerDecantInterface) -> DecantView {
        return DecantImplementation(controller: controller, parent: view)
    }
    
    func showSlices(controller: ControllerSlicesInterface) -> SlicesView {
        return SlicesImplementation(controller: controller, parent: view)
    }
    
    func editAccount(controller: ControllerEditAccountInterface) -> EditAccountView {
        return EditAccountImplementation(controller: controller, parent: view)
    }
    
    func refreshAccount(n: Int) {
        view.accountsTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: n, inSection: 0)], withRowAnimation: .None)
    }
    
    func removeAccount(n: Int) {
        view.accountsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: n, inSection: 0)], withRowAnimation: .Top)
    }
    
    func addAccount() {
        view.accountsTable.insertRowsAtIndexPaths([NSIndexPath(forRow: controller.numberOfAccounts()-1, inSection: 0)], withRowAnimation: .Top)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var controller: ControllerInterface? = nil

    @IBOutlet weak var accountsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let model = ModelImplementation(managedObjectContext: managedObjectContext)
        let controller = ControllerImplementation(model: model)
        let mainWindow = MainWindowImplementation(controller: controller, view: self)
        controller.setView(mainWindow)
        self.controller = controller
        //
//        model.addAccountAnUpdate("XXX", value: 1, isNegative: false)
//        model.addAccountAnUpdate("YYY", value: 2, isNegative: false)
//        model.addAccountAnUpdate("ZZZ", value: -3, isNegative: true)
//        model.addAccountAnUpdate("UUU", value: 4, isNegative: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let selectedRow = accountsTable.indexPathForSelectedRow {
            accountsTable.deselectRowAtIndexPath(selectedRow, animated: false)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "" {
        case "EditAccount":
            if let editAccount = sender as? EditAccountImplementation {
                editAccount.setView(segue.destinationViewController as! EditAccountViewController)
            }
        case "CreateAccount":
            if let createAccount = sender as? CreateAccountImplementation {
                createAccount.setView(segue.destinationViewController as! CreateAccountViewController)
            }
        case "Decant":
            if let decant = sender as? DecantImplementation {
                decant.setView(segue.destinationViewController as! DecantViewController)
            }
        default: break
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller!.numberOfAccounts()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell")
        if let account = controller?.account(indexPath.row) {
            cell?.textLabel?.text = account.name()
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            cell?.detailTextLabel?.text = numberFormatter.stringFromNumber(account.value())
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        controller?.account(indexPath.row)?.edit()
        return indexPath
    }
    
    @IBAction func buttonPlusClicked(sender: UIBarButtonItem) {
        controller?.createAccount()
    }
    
    @IBAction func buttonDecantClicked(sender: AnyObject) {
        controller?.decant()
    }
    
    @IBAction func buttonSlicesClicked(sender: AnyObject) {
        controller?.showSlices()
    }
}

