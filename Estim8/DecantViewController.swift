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
    
    func textFieldDiddBeginEditing(textField: UITextField) {
        parent?.pickler.hidden = true
        super.textFieldDidBeginEditing(textField)
    }
    
}

class DecantChildViewController: UITableViewController {
    
    @IBOutlet weak var fromCell: UITableViewCell!
    
    @IBOutlet weak var toCell: UITableViewCell!
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBOutlet var settingsTable: UITableView!
    
    var amountTextDelegate: NumberOnlyText? = nil
    
    weak var parent: DecantViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let p = parent {
            amountTextDelegate = DecantNumberOnlyText(parent: p)
            amountTextDelegate?.setTextField(amountText, showSign: false)
            parent?.setContainerHeightValue(settingsTable.rectForSection(0).height)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let center = NSNotificationCenter.defaultCenter()
        if let p = parent {
            center.addObserver(p, selector: #selector(DecantViewController.notificationValueChanged), name: UITextFieldTextDidChangeNotification, object: amountText)
        }
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            amountText.resignFirstResponder()
            parent?.showPickler(false)
            break
        case 1:
            amountText.becomeFirstResponder()
        case 2:
            amountText.resignFirstResponder()
            parent?.showPickler(true)
            break
        default:
            break
        }
    }
    
    func getAmount() -> NSDecimalNumber? {
        return amountTextDelegate?.getValue()
    }
    
    func setCellDetails(to: Bool, title: String, detail: String?) {
        let cell = to ? toCell : fromCell
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
    }
    
}

class DecantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    var parentNavigationBarHidden: Bool = false
    
    var viewImplementation: DecantImplementation? = nil
    
    func setViewImplementation(viewImplementation: DecantImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    var fromSelected: Int = 0
    
    var toSelected: Int = 1
    
    var editingTo: Bool = false
    
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    var child: DecantChildViewController? = nil
    
    @IBOutlet weak var pickler: UIPickerView!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(buttonDoneClicked))
        numberFormatter.numberStyle = .DecimalStyle
        scroll.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        parentNavigationBarHidden = navigationController?.navigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        scroll.directionalLockEnabled = true
        pickler.dataSource = self
        pickler.delegate = self
        pickler.hidden = true
        fixFromToCells()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(parentNavigationBarHidden, animated: animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewWillDisappear(animated)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y)
    }
    
    func somethingChanged() {
        if let amount = child?.getAmount(), let controller = viewImplementation?.controller {
            navigationItem.rightBarButtonItem?.enabled = controller.canDecant(fromSelected, to: toSelected, amount: amount)
        }
    }
    
    func fixFromToCells() {
        if let controller = viewImplementation?.controller {
            if let fromAccount = controller.account(fromSelected) {
                child?.setCellDetails(false, title: fromAccount.name(), detail: numberFormatter.stringFromNumber(fromAccount.value()))
            } else {
                child?.setCellDetails(false, title: "unknown", detail: "--")
            }
            if let toAccount = controller.account(toSelected) {
                child?.setCellDetails(true, title: toAccount.name(), detail: numberFormatter.stringFromNumber(toAccount.value()))
            } else {
                child?.setCellDetails(true, title: "unknown", detail: "--")
            }
        }
        somethingChanged()
    }
    
    func buttonDoneClicked() {
        if let amount = child?.getAmount() {
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
    
    func notificationValueChanged(notification: NSNotification) {
        somethingChanged()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "" {
        case "DecantEmbed":
            if let c = segue.destinationViewController as? DecantChildViewController {
                c.parent = self
                child = c
            }
        default:
            break
        }
    }
    
    func showPickler(to: Bool) {
        editingTo = to
        pickler.hidden = false
        pickler.selectRow(to ? toSelected : fromSelected, inComponent: 0, animated: true)
    }
    
    func setContainerHeightValue(height: CGFloat) {
        containerHeight.constant = height
    }

}
