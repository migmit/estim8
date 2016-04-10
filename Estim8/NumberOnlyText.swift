//
//  NumberOnlyText.swift
//  Estim8
//
//  Created by MigMit on 10/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class NumberOnlyText: NSObject, UITextFieldDelegate {
    
    var value: Float = 0
    
    var initialUsesGroupingSeparator: Bool = false
    
    var isEditing: Bool = false
    
    let numberFormatter: NSNumberFormatter
    
    override init() {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        super.init()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (!isEditing) {
            isEditing = true
            initialUsesGroupingSeparator = numberFormatter.usesGroupingSeparator
            numberFormatter.usesGroupingSeparator = false
            textField.text = numberFormatter.stringFromNumber(value)
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (isEditing) {
            isEditing = false
            let text = textField.text ?? ""
            if (text.isEmpty) {
                value = 0
            } else if let v = numberFormatter.numberFromString(text) {
                value = v.floatValue
            }
            numberFormatter.usesGroupingSeparator = initialUsesGroupingSeparator
            textField.text = numberFormatter.stringFromNumber(value)
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if (text.isEmpty) {
            return true
        } else if let _ = numberFormatter.numberFromString(text)?.floatValue {
            return true
        } else {
            return false
        }
    }

}
