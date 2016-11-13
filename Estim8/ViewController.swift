//
//  ViewController.swift
//  Estim8
//
//  Created by MigMit on 02/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var controller: ControllerAccountsInterface? = nil
    
    @IBOutlet weak var accountsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        self.controller = controllers.accounts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectedRow = accountsTable.indexPathForSelectedRow {
            accountsTable.deselectRow(at: selectedRow, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "EditAccount":
            if let editAccountController = sender as? ControllerEditAccountInterface {
                (segue.destination as! EditAccountViewController).setController(editAccountController)
            }
        case "CreateAccount":
            if let createController = sender as? ControllerCreateAccountInterface {
                (segue.destination as! CreateAccountViewController).setController(createController)
            }
        case "Decant":
            if let decantController = sender as? ControllerDecantInterface {
                (segue.destination as! DecantViewController).setController(decantController)
            }
        default: break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.numberOfAccounts() ?? 0
    }
    
    func getAccount(_ n: Int) -> ControllerAccountInterface? {
        return controller?.account(n) {(accountResponse) in
            switch accountResponse {
            case .Remove(let index): self.removeAccount(index)
            case .Refresh(let index): self.refreshAccount(index)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell")
        if let account = getAccount((indexPath as NSIndexPath).row) {
            cell?.textLabel?.text = account.name()
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let valueText = numberFormatter.string(from: account.value())
            cell?.detailTextLabel?.text = valueText.map{$0 + account.currency().symbol()}
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let account = getAccount((indexPath as NSIndexPath).row) {
            let editController = account.edit()
            performSegue(withIdentifier: "EditAccount", sender: editController)
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let account = getAccount((indexPath as NSIndexPath).row) {
            let alert = UIAlertController(title: account.name(), message: "Delete?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {_ in account.remove()})
            alert.addAction(UIAlertAction(title: "No", style: .cancel) {_ in tableView.setEditing(false, animated: true)})
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonPlusClicked(_ sender: UIBarButtonItem) {
        if let c = controller {
            let createController = c.createAccount { _ in self.addAccount() }
            performSegue(withIdentifier: "CreateAccount", sender: createController)
        }
    }
    
    @IBAction func buttonDecantClicked(_ sender: AnyObject) {
        if let c = controller {
            let decantController = c.decant{(fromTo) in
                let (from, to) = fromTo
                self.refreshAccount(from)
                self.refreshAccount(to)
            }
            performSegue(withIdentifier: "Decant", sender: decantController)
        }
    }
    
    func refreshAccount(_ n: Int) {
        accountsTable.reloadRows(at: [IndexPath(row: n, section: 0)], with: .none)
    }
    
    func removeAccount(_ n: Int) {
        accountsTable.deleteRows(at: [IndexPath(row: n, section: 0)], with: .top)
    }
    
    func addAccount() {
        if let c = controller {
            accountsTable.insertRows(at: [IndexPath(row: c.numberOfAccounts()-1, section: 0)], with: .top)
        }
    }

}

