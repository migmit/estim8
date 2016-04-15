//
//  NumberOnlyText.swift
//  Estim8
//
//  Created by MigMit on 10/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

class NumberOnlyText: NSObject, UITextFieldDelegate {
    
    var initialUsesGroupingSeparator: Bool = false
    
    var isEditing: Bool = false
    
    private var isNegative: Bool = false
    
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
        let keyboardToolbar = UIToolbar()
        let pmButton = UIBarButtonItem(title: "+/-", style: .Plain, target: self, action: #selector(pmButtonClicked))
        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        keyboardToolbar.items = [leftFlexibleSpace, pmButton, rightFlexibleSpace]
        keyboardToolbar.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        textField.inputAccessoryView = keyboardToolbar
        textField.autocorrectionType = .No
        textField.keyboardType = .DecimalPad
    }
    
    func pmButtonClicked() {
        isNegative = !isNegative
        setFieldText(getValue().decimalNumberByMultiplyingBy(-1))
        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: textField)
    }
    
    func zeroRepresentation() -> String {
        return isEditing ? (isNegative ? "-" : "") : "0"
    }
    
    func setFieldText(value: NSDecimalNumber) {
        textField?.text = value == 0 ? zeroRepresentation() : numberFormatter.stringFromNumber(value)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (!isEditing) {
            let value = getValue()
            isEditing = true
            initialUsesGroupingSeparator = numberFormatter.usesGroupingSeparator
            numberFormatter.usesGroupingSeparator = false
            setFieldText(value)
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (isEditing) {
            isEditing = false
            let value = getValue()
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
        setFieldText(value)
        if (value != 0) {
            isNegative = value.compare(0) == .OrderedAscending
        }
    }
    
    func getValue() -> NSDecimalNumber {
        return textToNumber(textField?.text ?? "") ?? 0
    }
    
    func setIsNegative(isNegative: Bool) {
        if (getValue() == 0) {
            self.isNegative = isNegative
            setFieldText(0)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if let val = textToNumber(text) {
            if (val != 0) {
                isNegative = val.compare(0) == .OrderedAscending
            }
            return true
        } else {
            return false
        }
    }

}
