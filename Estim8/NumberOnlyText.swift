//
//  NumberOnlyText.swift
//  Estim8
//
//  Created by MigMit on 10/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class NumberOnlyText: NSObject, UITextFieldDelegate {
    
    private var value: NSDecimalNumber = 0
    
    var initialUsesGroupingSeparator: Bool = false
    
    var isEditing: Bool = false
    
    let numberFormatter: NSNumberFormatter
    
    private var textField: UITextField? = nil
    
    override init() {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        super.init()
    }
    
    func setTextField(textField: UITextField) {
        self.textField = textField
        textField.delegate = self
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (!isEditing) {
            isEditing = true
            initialUsesGroupingSeparator = numberFormatter.usesGroupingSeparator
            numberFormatter.usesGroupingSeparator = false
            textField.text = value == 0 ? "" : numberFormatter.stringFromNumber(value)
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (isEditing) {
            isEditing = false
            value = getValue()
            numberFormatter.usesGroupingSeparator = initialUsesGroupingSeparator
            textField.text = numberFormatter.stringFromNumber(value)
        }
        return true
    }
    
    func textToNumber(from: String) -> NSDecimalNumber? {
        if (from.isEmpty || from == "-") {
            return 0
        } else if let v = numberFormatter.numberFromString(from) {
            return NSDecimalNumber(decimal: v.decimalValue)
        } else {
            return nil
        }
    }
    
    func setValue(value: NSDecimalNumber) {
        self.value = value
    }
    
    func getValue() -> NSDecimalNumber {
        return textToNumber(textField?.text ?? "") ?? value
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return textToNumber(text) != nil
    }

}
