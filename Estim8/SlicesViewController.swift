//
//  SlicesViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class SlicesImplementation: SlicesView {
    
    let controller: ControllerSlicesInterface
    
    let parent: ViewController
    
    weak var view: SlicesViewController? = nil
    
    init(controller: ControllerSlicesInterface, parent: ViewController) {
        self.controller = controller
        self.parent = parent
    }
    
    func setView(view: SlicesViewController) {
        self.view = view
        view.setViewImplementation(self)
    }
    
    func showSubView() {
        parent.performSegueWithIdentifier("Slices", sender: self)
    }
    
    func hideSubView() {
        view?.dismissViewControllerAnimated(true, completion: nil)
    }

    func createSlice(slice: ControllerSliceInterface) {
        view?.refreshCurrentSlice(slice)
    }
    
    func removeSlice(slice: ControllerSliceInterface) {
        view?.refreshCurrentSlice(slice)
    }
}

class SlicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let panPointsCount = 24
    
    var viewImplementation: SlicesImplementation? = nil
    
    var currentSlice: ControllerSliceInterface? = nil
    
    var oldSliceNumber: Int? = nil
    
    @IBOutlet weak var updatesTable: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    func setViewImplementation(viewImplementation: SlicesImplementation) {
        self.viewImplementation = viewImplementation
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panEvent))
        updatesTable.addGestureRecognizer(panRecognizer)
        if let slice = viewImplementation?.controller.slice(0) {
            refreshCurrentSlice(slice)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewImplementation?.controller.numberOfAccounts() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UpdateCell")
        if let account = currentSlice?.account(indexPath.row) {
            cell?.textLabel?.text = account.name()
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            cell?.detailTextLabel?.text = numberFormatter.stringFromNumber(account.value())
        } else {
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }
    
    func refreshCurrentSlice(slice: ControllerSliceInterface) {
        var toolbarItems = toolbar.items ?? []
        currentSlice = slice
        let isCreateButton = slice.buttonCalledCreate()
        toolbarItems[0] = UIBarButtonItem(barButtonSystemItem: isCreateButton ? .Compose : .Trash, target: self, action: #selector(createDeleteButtonClicked))
        if let _ = slice.next() {
            toolbarItems[2].enabled = true
        } else {
            toolbarItems[2].enabled = false
        }
        if let _ = slice.prev() {
            toolbarItems[4].enabled = true
        } else {
            toolbarItems[4].enabled = false
        }
        toolbar.items = toolbarItems
        updatesTable.reloadData()
    }
    
    func createDeleteButtonClicked() {
        currentSlice?.createOrRemove()
    }
    
    @IBAction func leftButtonClicked(sender: UIBarButtonItem) {
        if let slice = currentSlice?.next() {
            refreshCurrentSlice(slice)
        }
    }
    
    @IBAction func rightButtonClicked(sender: UIBarButtonItem) {
        if let slice = currentSlice?.prev() {
            refreshCurrentSlice(slice)
        }
    }
    
    @IBAction func closeButtonClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func panEvent(recogniser: UIGestureRecognizer) {
        if let pan = recogniser as? UIPanGestureRecognizer {
            switch pan.state {
            case .Changed:
                if (oldSliceNumber == nil) {
                    oldSliceNumber = currentSlice?.sliceIndex()
                }
                let shift = pan.translationInView(updatesTable).x
                let shiftPoints = Int(shift * CGFloat(panPointsCount) / updatesTable.bounds.width)
                if let sliceCount = viewImplementation?.controller.numberOfSlices() {
                    let newSliceNumber = oldSliceNumber! - shiftPoints
                    let sliceNumber = newSliceNumber < 0 ? 0 : newSliceNumber >= sliceCount ? sliceCount-1 : newSliceNumber
                    if let slice = viewImplementation?.controller.slice(sliceNumber) {
                        refreshCurrentSlice(slice)
                    }
                }
            default:
                oldSliceNumber = nil
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
