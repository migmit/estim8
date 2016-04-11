//
//  EditAccountViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class EditAccountImplementation: EditAccountView {
    
    weak var controller: ControllerEditAccountInterface?
    
    let parent: ViewController
    
    weak var view: EditAccountViewController? = nil
    
    init(controller: ControllerEditAccountInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: EditAccountViewController) {
        self.view = view
        view.setController(controller!)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("EditAccount", sender: self)
    }
    
    func hideSubView() {
        view?.navigationController?.popViewControllerAnimated(true)
    }
}

class EditAccountViewController: UITableViewController {
    
    var controller: ControllerEditAccountInterface? = nil
    
    @IBOutlet weak var accountNameLabel: UILabel!

    @IBOutlet weak var accountValueText: UITextField!
    
    var accountValueTextDelegate: NumberOnlyText = NumberOnlyText()
    
    var parentNavigationBarHidden: Bool = false
    
    func setController(controller: ControllerEditAccountInterface) {
        self.controller = controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(buttonSaveClicked))
        accountValueText.delegate = accountValueTextDelegate
        if let controller = self.controller {
            accountNameLabel.text = controller.name()
            accountValueTextDelegate.value = controller.value()
            accountValueText.text = accountValueTextDelegate.numberFormatter.stringFromNumber(controller.value())
        }
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
            accountValueText.becomeFirstResponder()
        default:
            break;
        }
    }

    @IBAction func buttonDeleteClicked(sender: UIButton) {
        let alert = UIAlertController(title: controller?.name() ?? "", message: "Delete?", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: {_ in self.controller?.remove()}))
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func buttonSaveClicked() {
        accountValueText.resignFirstResponder()
        let value = accountValueTextDelegate.value
        if (!(controller?.setValue(value) ?? false)) {
            let alert = UIAlertController(title: "Error", message: "Can't set the value of \(controller?.name() ?? "the account") to \(value)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
