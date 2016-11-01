//
//  DecantViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class DecantChildViewController: UITableViewController, NumberFieldDelegate {
    
    @IBOutlet weak var fromCell: UITableViewCell!
    
    @IBOutlet weak var toCell: UITableViewCell!
    
    @IBOutlet weak var amountText: NumberField!
    
    @IBOutlet var settingsTable: UITableView!
    
    weak var parentController: DecantViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountText.numberDelegate = self
        amountText.showSign(false)
        parentController?.setContainerHeightValue(settingsTable.rect(forSection: 0).height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let center = NotificationCenter.default
        if let p = parentController {
            center.addObserver(p, selector: #selector(DecantViewController.notificationValueChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: amountText)
        }
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).row {
        case 0:
            amountText.resignFirstResponder()
            parentController?.showPickler(false)
            break
        case 1:
            amountText.becomeFirstResponder()
        case 2:
            amountText.resignFirstResponder()
            parentController?.showPickler(true)
            break
        default:
            break
        }
    }
    
    func numberFieldDidBeginEditing(_ numberField: NumberField) {
        parentController?.pickler.isHidden = true
    }
    
    func getAmount() -> NSDecimalNumber? {
        return amountText.getValue()
    }
    
    func setCellDetails(_ to: Bool, title: String, detail: String?) {
        let cell = to ? toCell : fromCell
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = detail
    }
    
}

class DecantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    var parentNavigationBarHidden: Bool = false
    
    var controller: ControllerDecantInterface? = nil
    
    func setController(_ controller: ControllerDecantInterface) {
        self.controller = controller
    }
    
    var fromSelected: Int = 0
    
    var toSelected: Int = 1
    
    var editingTo: Bool = false
    
    let numberFormatter: NumberFormatter = NumberFormatter()
    
    var child: DecantChildViewController? = nil
    
    @IBOutlet weak var pickler: UIPickerView!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonDoneClicked))
        numberFormatter.numberStyle = .decimal
        scroll.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parentNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        scroll.isDirectionalLockEnabled = true
        pickler.dataSource = self
        pickler.delegate = self
        pickler.isHidden = true
        fixFromToCells()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(parentNavigationBarHidden, animated: animated)
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return controller?.numberOfAccounts() ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return controller?.account(row)?.name()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (editingTo) {
            toSelected = row
        } else {
            fromSelected = row
        }
        fixFromToCells()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
    }
    
    func somethingChanged() {
        if let amount = child?.getAmount(), let c = controller {
            navigationItem.rightBarButtonItem?.isEnabled = c.canDecant(fromSelected, to: toSelected, amount: amount, useFromCurrency: true)
        }
    }
    
    func fixFromToCells() {
        if let c = controller {
            if let fromAccount = c.account(fromSelected) {
                child?.setCellDetails(false, title: fromAccount.name(), detail: numberFormatter.string(from: fromAccount.value()))
            } else {
                child?.setCellDetails(false, title: "unknown", detail: "--")
            }
            if let toAccount = c.account(toSelected) {
                child?.setCellDetails(true, title: toAccount.name(), detail: numberFormatter.string(from: toAccount.value()))
            } else {
                child?.setCellDetails(true, title: "unknown", detail: "--")
            }
        }
        somethingChanged()
    }
    
    func buttonDoneClicked() {
        if let amount = child?.getAmount() {
            if let c = controller {
                if (c.act(DecantCommand(from: fromSelected, to: toSelected, amount: amount, useFromCurrency: true))) {
                    _ = navigationController?.popViewController(animated: true)
                } else {
                    let fromAccountName = c.account(fromSelected)?.name() ?? "<unknown>"
                    let toAccountName = c.account(toSelected)?.name() ?? "<unknown>"
                    let alert = UIAlertController(title: "Error", message: "Can't decant \(amount) from \"\(fromAccountName)\" to \"\(toAccountName)\"", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func notificationValueChanged(_ notification: Notification) {
        somethingChanged()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "DecantEmbed":
            if let c = segue.destination as? DecantChildViewController {
                c.parentController = self
                child = c
            }
        default:
            break
        }
    }
    
    func showPickler(_ to: Bool) {
        editingTo = to
        pickler.isHidden = false
        pickler.selectRow(to ? toSelected : fromSelected, inComponent: 0, animated: true)
    }
    
    func setContainerHeightValue(_ height: CGFloat) {
        containerHeight.constant = height
    }
    
}
