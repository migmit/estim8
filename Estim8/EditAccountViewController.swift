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
    
    func setView(_ view: EditAccountViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegue(withIdentifier: "EditAccount", sender: self)
    }
    
    func hideSubView() {
        _ = view?.navigationController?.popViewController(animated: true)
    }
    
    func selectCurrency(_ controller: ControllerListCurrenciesInterface) -> ListCurrenciesView {
        return ListCurrenciesImplementation(controller: controller, parent: view!)
    }
    
    func currencySelected(_ selected: ControllerROCurrencyInterface) {
        //TODO
    }
}

class EditAccountViewController: SubViewController, ListCurrenciesViewControllerInterface {
    
    var viewImplementation: EditAccountImplementation? = nil
    
    @IBOutlet weak var accountNameLabel: UILabel!

    @IBOutlet weak var accountValueText: NumberField!
    
    func setViewImplementation(_ viewImplementation: EditAccountImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    func showListCurrenciesView(_ sender: ListCurrenciesView) {
        performSegue(withIdentifier: "ListCurrencies", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonSaveClicked))
        if let controller = self.viewImplementation?.controller {
            accountNameLabel.text = controller.name()
            accountValueText.setValue(controller.value(), isNegative: controller.isNegative())
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
        if let controller = viewImplementation?.controller {
            let alert = UIAlertController(title: controller.name() , message: "Delete?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in controller.remove()}))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func buttonSaveClicked() {
        let value = accountValueText.getValue()
        if let controller = viewImplementation?.controller{
            if (!(controller.setValue(value))) {
                let alert = UIAlertController(title: "Error", message: "Can't set the value of \(controller.name()) to \(value)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func somethingChanged() {
        let value = accountValueText.getValue()
        if let controller = viewImplementation?.controller {
            navigationItem.rightBarButtonItem?.isEnabled = controller.canSetValue(value)
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
