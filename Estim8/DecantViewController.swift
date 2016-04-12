//
//  DecantViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class DecantImplementation: DecantView {
    
    let controller: ControllerDecantInterface
    
    let parent: ViewController
    
    weak var view: DecantViewController? = nil
    
    init(controller: ControllerDecantInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: DecantViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("Decant", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
}

class DecantNumberOnlyText: NumberOnlyText {
    
    weak var parent: DecantViewController? = nil
    
    init(parent: DecantViewController) {
        self.parent = parent
        super.init()
    }
    
    override func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        parent?.pickler.hidden = true
        return super.textFieldShouldBeginEditing(textField)
    }
    
}

class DecantViewController: SubViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var viewImplementation: DecantImplementation? = nil
    
    func setViewImplementation(viewImplementation: DecantImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    var fromSelected: Int = 0
    
    var toSelected: Int = 1
    
    var editingTo: Bool = false
    
    var amountTextDelegate: NumberOnlyText? = nil
    
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    @IBOutlet weak var fromCell: UITableViewCell!
    
    @IBOutlet weak var toCell: UITableViewCell!
    
    @IBOutlet weak var picklerCell: UITableViewCell!
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBOutlet weak var pickler: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(buttonDoneClicked))
        amountTextDelegate = DecantNumberOnlyText(parent: self)
        amountText.delegate = amountTextDelegate
        numberFormatter.numberStyle = .DecimalStyle
        pickler.dataSource = self
        pickler.delegate = self
        pickler.hidden = true
        fixFromToCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            editingTo = false
            amountText.resignFirstResponder()
            pickler.selectRow(fromSelected, inComponent: 0, animated: true)
            pickler.hidden = false
            break
        case 1:
            amountText.becomeFirstResponder()
        case 2:
            editingTo = true
            amountText.resignFirstResponder()
            pickler.selectRow(toSelected, inComponent: 0, animated: true)
            pickler.hidden = false
            break
        default:
            break
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let controller = viewImplementation?.controller {
            return controller.numberOfAccounts()
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let controller = viewImplementation?.controller {
            return controller.account(row)?.name()
        } else {
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (editingTo) {
            toSelected = row
        } else {
            fromSelected = row
        }
        fixFromToCells()
    }
    
    func fixFromToCells() {
        if let controller = viewImplementation?.controller {
            if let fromAccount = controller.account(fromSelected) {
                fromCell.textLabel?.text = fromAccount.name()
                fromCell.detailTextLabel?.text = numberFormatter.stringFromNumber(fromAccount.value())
            } else {
                fromCell.textLabel?.text = "unknown"
                fromCell.detailTextLabel?.text = "--"
            }
            if let toAccount = controller.account(toSelected) {
                toCell.textLabel?.text = toAccount.name()
                toCell.detailTextLabel?.text = numberFormatter.stringFromNumber(toAccount.value())
            } else {
                toCell.textLabel?.text = "unknown"
                toCell.detailTextLabel?.text = "--"
            }
        }
    }
    
    func buttonDoneClicked() {
        amountText.resignFirstResponder()
        if let amount = amountTextDelegate?.value {
            if let controller = viewImplementation?.controller {
                if (!(controller.decant(fromSelected, to: toSelected, amount: amount))) {
                    let fromAccountName = controller.account(fromSelected)?.name() ?? "<unknown>"
                    let toAccountName = controller.account(toSelected)?.name() ?? "<unknown>"
                    let alert = UIAlertController(title: "Error", message: "Can't decant \(amount) from \"\(fromAccountName)\" to \"\(toAccountName)\"", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
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
