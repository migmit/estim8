//
//  SlicesViewController.swift
//  Estim8
//
//  Created by MigMit on 09/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class SlicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    struct Panning {
        
        class Row {
            
            let transitionAccount: ControllerTransitionInterface
            
            let rowOffset: CGFloat
            
            let pointOffset: CGFloat
            
            init?(slice: ControllerSliceInterface?, updatesTable: UITableView, touchPoint: CGPoint) {
                if let indexPath = updatesTable.indexPathForRow(at: touchPoint) {
                    let cellTop = updatesTable.rectForRow(at: indexPath).minY
                    if let transitionAccount = slice?.account((indexPath as NSIndexPath).row)?.transition() {
                        self.transitionAccount = transitionAccount
                        self.rowOffset = touchPoint.y - cellTop
                        self.pointOffset = touchPoint.y - updatesTable.contentOffset.y
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
            
            func bounceBack(_ updatesTable: UITableView) {
                let maximumOffset = updatesTable.contentSize.height - updatesTable.bounds.height
                if (updatesTable.contentOffset.y < 0) {
                    updatesTable.setContentOffset(CGPoint(x: updatesTable.contentOffset.x, y: 0), animated: true)
                } else if (updatesTable.contentOffset.y > maximumOffset && maximumOffset > 0) {
                    updatesTable.setContentOffset(CGPoint(x: updatesTable.contentOffset.x, y: maximumOffset), animated: true)
                }
            }
            
            func translate(_ slice: ControllerSliceInterface, updatesTable: UITableView) {
                if let transition = slice.whereToMove(transitionAccount) {
                    let (rowNumber, isVisible) = transition
                    let pointY: CGFloat
                    if (isVisible) {
                        pointY = updatesTable.rectForRow(at: IndexPath(row: rowNumber, section: 0)).minY + rowOffset
                    } else {
                        if (rowNumber == 0) {
                            pointY = 0
                        } else {
                            pointY = updatesTable.rectForRow(at: IndexPath(row: rowNumber-1, section: 0)).maxY
                        }
                    }
                    let contentOffset = pointY - pointOffset
                    updatesTable.contentOffset = CGPoint(x: updatesTable.contentOffset.x, y: contentOffset)
                }
            }
            
        }
        
        let oldSliceNumber: Int
        
        let scrollingHorizontally: Bool
        
        let row: Row?
        
    }
    
    let panPointsCount = 24
    
    var controller: ControllerSlicesInterface? = nil
    
    var currentSlice: ControllerSliceInterface? = nil
    
    var panning: Panning? = nil
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    @IBOutlet weak var updatesTable: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var titleBar: UINavigationBar!
    
    func setController(_ controller: ControllerSlicesInterface) {
        self.controller = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panEvent))
        panRecognizer.delegate = self
        updatesTable.addGestureRecognizer(panRecognizer)
        if let slice = controller?.slice(0) {
            refreshCurrentSlice(slice)
        }
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSlice?.numberOfAccounts() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell")
        if let account = currentSlice?.account((indexPath as NSIndexPath).row) {
            cell?.textLabel?.text = account.name()
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let valueText = numberFormatter.string(from: account.value())
            cell?.detailTextLabel?.text = valueText.map{$0 + account.currency().symbol()}
        } else {
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            if let p = panning {
                return !p.scrollingHorizontally
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func refreshCurrentSlice(_ slice: ControllerSliceInterface) {
        var toolbarItems = toolbar.items ?? []
        currentSlice = slice
        let isCreateButton = slice.buttonCalledCreate()
        toolbarItems[0] = UIBarButtonItem(barButtonSystemItem: isCreateButton ? .compose : .trash, target: self, action: #selector(createDeleteButtonClicked))
        toolbarItems[2].isEnabled = slice.next() != nil
        if let _ = slice.next() {
            toolbarItems[2].isEnabled = true
        } else {
            toolbarItems[2].isEnabled = false
        }
        if let _ = slice.prev() {
            toolbarItems[4].isEnabled = true
        } else {
            toolbarItems[4].isEnabled = false
        }
        toolbar.items = toolbarItems
        updatesTable.reloadData()
        if let date = slice.sliceDate() {
            titleBar.topItem?.title = dateFormatter.string(from: date as Date)
        } else {
            titleBar.topItem?.title = "Current state"
        }
    }
    
    func createDeleteButtonClicked() {
        if let slice = currentSlice {
            refreshCurrentSlice(slice.createOrRemove())
        }
    }
    
    @IBAction func leftButtonClicked(_ sender: UIBarButtonItem) {
        if let slice = currentSlice?.next() {
            refreshCurrentSlice(slice)
        }
    }
    
    @IBAction func rightButtonClicked(_ sender: UIBarButtonItem) {
        if let slice = currentSlice?.prev() {
            refreshCurrentSlice(slice)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func panEvent(_ recogniser: UIGestureRecognizer) {
        if let pan = recogniser as? UIPanGestureRecognizer {
            switch pan.state {
            case .changed:
                let shiftX = pan.translation(in: updatesTable).x
                let shiftY = pan.translation(in: updatesTable).y
                if let cs = currentSlice {
                    if (panning == nil) {
                        panning = Panning(
                            oldSliceNumber: cs.sliceIndex(),
                            scrollingHorizontally: fabs(shiftY) < fabs(shiftX),
                            row: Panning.Row(slice: currentSlice, updatesTable: updatesTable, touchPoint: pan.location(in: updatesTable))
                        )
                    }
                }
                if let p = panning {
                    if (p.scrollingHorizontally) {
                        let shiftPoints = Int(shiftX * CGFloat(panPointsCount) / updatesTable.bounds.width)
                        if let sliceCount = controller?.numberOfSlices() {
                            let newSliceNumber = p.oldSliceNumber + shiftPoints // shifting backwards
                            let sliceNumber = newSliceNumber < 0 ? 0 : newSliceNumber >= sliceCount ? sliceCount-1 : newSliceNumber
                            if (sliceNumber != currentSlice?.sliceIndex()) {
                                if let slice = controller?.slice(sliceNumber) {
                                    refreshCurrentSlice(slice)
                                    p.row?.translate(slice, updatesTable: updatesTable)
                                }
                            }
                        }
                    }
                    
                }
            default:
                panning?.row?.bounceBack(updatesTable)
                panning = nil
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
