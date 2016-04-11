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

class CreateAccountViewController: UITableViewController {

    var viewImplementation: CreateAccountImplementation? = nil
    
    var parentNavigationBarHidden: Bool = false
    
    @IBOutlet weak var accountTitleText: UITextField!
    
    @IBOutlet weak var accountValueText: UITextField!
    
    @IBOutlet weak var positiveCell: UITableViewCell!
    
    @IBOutlet weak var negativeCell: UITableViewCell!
    
    let accountValueTextDelegate: NumberOnlyText = NumberOnlyText()
    
    var isNegative: Bool = false
    
    func setViewImplementation(viewImplementation: CreateAccountImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(buttonSaveClicked))
        accountValueText.delegate = accountValueTextDelegate
        accountTitleText.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        parentNavigationBarHidden = navigationController?.navigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(parentNavigationBarHidden, animated: animated)
        super.viewWillDisappear(animated)
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
            } else {
                isNegative = false
                positiveCell.accessoryType = .Checkmark
                negativeCell.accessoryType = .None
            }
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func buttonSaveClicked() {
        accountValueText.resignFirstResponder()
        let title = accountTitleText.text ?? ""
        let value = accountValueTextDelegate.value
        if let controller = viewImplementation?.controller {
            if (!(controller.create(title, initialValue: value, isNegative: isNegative) ?? false)) {
                let alert = UIAlertController(title: "Error", message: "Can't create \(isNegative ? "negative" : "positive") account \"\(title)\" with value \(value)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
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
