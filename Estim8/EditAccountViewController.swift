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
    
    var view: EditAccountViewController? = nil
    
    init(controller: ControllerEditAccountInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: EditAccountViewController) {
        self.view = view
        view.setController(controller)
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
    
    var parentNavigationBarHidden: Bool = false
    
    func setController(controller: ControllerEditAccountInterface) {
        self.controller = controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(buttonSaveClicked))
        if let controller = self.controller {
            accountNameLabel.text = controller.name()
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            accountValueText.text = numberFormatter.stringFromNumber(controller.value())
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

    @IBAction func buttonDeleteClicked(sender: UIButton) {
        controller?.remove()
    }
    
    func buttonSaveClicked() {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        if let value = numberFormatter.numberFromString(accountValueText.text ?? "")?.floatValue {
            if (!(controller?.setValue(value) ?? false)) {
                let alert = UIAlertController(title: "Error", message: "Can't set the value of \(controller?.name() ?? "the account") to \(value)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Wrong value: \"\(accountValueText.text ?? "")\"", preferredStyle: .Alert)
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
