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
    
    var view: ViewController? = nil
    
    init(controller: ControllerInterface, view: ViewController) {
        self.controller = controller
        self.view = view
    }
    
    func createAccount(_ controller: ControllerCreateAccountInterface) -> CreateAccountView {
        return CreateAccountImplementation(controller: controller, parent: view!)
    }
    
    func decant(_ controller: ControllerDecantInterface) -> DecantView {
        return DecantImplementation(controller: controller, parent: view!)
    }
    
    func showSlices(_ controller: ControllerSlicesInterface) -> SlicesView {
        return SlicesImplementation(controller: controller, parent: view!)
    }
    
    func editAccount(_ controller: ControllerEditAccountInterface) -> EditAccountView {
        return EditAccountImplementation(controller: controller, parent: view!)
    }
    
    func refreshAccount(_ n: Int) {
        view?.accountsTable.reloadRows(at: [IndexPath(row: n, section: 0)], with: .none)
    }
    
    func removeAccount(_ n: Int) {
        view?.accountsTable.deleteRows(at: [IndexPath(row: n, section: 0)], with: .top)
    }
    
    func addAccount() {
        view?.accountsTable.insertRows(at: [IndexPath(row: controller.numberOfAccounts()-1, section: 0)], with: .top)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let updateInterval: TimeInterval = 24*60*60
    
    let sinceLastUpdate: TimeInterval = 12*60*60
    
    var viewImplementation: MainWindowImplementation? = nil
    
    var updater: UpdaterFrontend? = nil

    @IBOutlet weak var accountsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let model = ModelImplementation(managedObjectContext: managedObjectContext)
        let updater = UpdaterFrontendImpl(model: model, updateInterval: updateInterval, sinceLastUpdate: sinceLastUpdate, backend: UpdaterBackendECBImpl())
        let controller = ControllerImplementation(model: model)
        let mainWindow = MainWindowImplementation(controller: controller, view: self)
        updater.startUpdating()
        controller.setView(mainWindow)
        self.viewImplementation = mainWindow
        self.updater = updater
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
            if let editAccount = sender as? EditAccountImplementation {
                editAccount.setView(segue.destination as! EditAccountViewController)
            }
        case "CreateAccount":
            if let createAccount = sender as? CreateAccountImplementation {
                createAccount.setView(segue.destination as! CreateAccountViewController)
            }
        case "Decant":
            if let decant = sender as? DecantImplementation {
                decant.setView(segue.destination as! DecantViewController)
            }
        case "Slices":
            if let slices = sender as? SlicesImplementation {
                slices.setView(segue.destination as! SlicesViewController)
            }
        default: break
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let controller = viewImplementation?.controller {
            return controller.numberOfAccounts()
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell")
        if let account = viewImplementation?.controller.account((indexPath as NSIndexPath).row) {
            cell?.textLabel?.text = account.name()
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let valueText = numberFormatter.string(from: account.value())
            cell?.detailTextLabel?.text = valueText.map{$0 + account.currency().symbol()}
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let controller = viewImplementation?.controller {
            controller.account((indexPath as NSIndexPath).row)?.edit()
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
        if let controller = viewImplementation?.controller {
            let alert = UIAlertController(title: controller.account((indexPath as NSIndexPath).row)?.name() ?? "", message: "Delete?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in controller.account((indexPath as NSIndexPath).row)?.remove()}))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in tableView.setEditing(false, animated: true)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonPlusClicked(_ sender: UIBarButtonItem) {
        viewImplementation?.controller.createAccount()
    }
    
    @IBAction func buttonDecantClicked(_ sender: AnyObject) {
        viewImplementation?.controller.decant()
    }
    
    @IBAction func buttonSlicesClicked(_ sender: AnyObject) {
        viewImplementation?.controller.showSlices()
    }
}

