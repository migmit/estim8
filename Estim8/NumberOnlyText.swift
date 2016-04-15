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
    
    private var isNegative: Bool = false
    
    let numberFormatter: NSNumberFormatter
    
    private var textField: UITextField? = nil
    
    private var leftView: UILabel? = nil
    
    override init() {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        super.init()
    }
    
    func setTextField(textField: UITextField, showSign: Bool) {
        self.textField = textField
        textField.delegate = self
//        let keyboardToolbar = UIToolbar()
//        let pmButton = UIBarButtonItem(title: "+/-", style: .Plain, target: self, action: #selector(pmButtonClicked))
//        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
//        let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
//        keyboardToolbar.items = [leftFlexibleSpace, pmButton, rightFlexibleSpace]
//        keyboardToolbar.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//        textField.inputAccessoryView = keyboardToolbar
        if (showSign) {
            let h = textField.bounds.height
            let leftView: UILabel = UILabel(frame: CGRectMake(0, 0, h, h))
            leftView.textAlignment = .Center
            textField.leftView = leftView
            textField.leftViewMode = .Always
            self.leftView = leftView
            adjustLeftView()
        }
        textField.borderStyle = .RoundedRect
        textField.textAlignment = .Left
        textField.autocorrectionType = .No
        textField.keyboardType = .DecimalPad
    }
    
//    func pmButtonClicked() {
//        isNegative = !isNegative
//        setFieldText(getValue().decimalNumberByMultiplyingBy(-1))
//        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: textField)
//    }
//    
    func zeroRepresentation() -> String {
        if let isEditing = textField?.editing {
            return isEditing ? "" : "0"
        } else {
            return "0"
        }
    }
    
    func setFieldText(value: NSDecimalNumber) {
        switch value.compare(0) {
        case .OrderedAscending:
            textField?.text = numberFormatter.stringFromNumber(value.decimalNumberByMultiplyingBy(-1))
        case .OrderedSame:
            textField?.text = zeroRepresentation()
        case .OrderedDescending:
            textField?.text = numberFormatter.stringFromNumber(value)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let value = getValue()
        initialUsesGroupingSeparator = numberFormatter.usesGroupingSeparator
        numberFormatter.usesGroupingSeparator = false
        setFieldText(value)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let value = getValue()
        numberFormatter.usesGroupingSeparator = initialUsesGroupingSeparator
        setFieldText(value)
    }
    
    func textToNumber(from: String) -> NSDecimalNumber? {
        if (from.isEmpty) {
            return 0
        } else if let v = numberFormatter.numberFromString(from) {
            if (v.compare(0) != .OrderedAscending) {
                return NSDecimalNumber(decimal: v.decimalValue)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setIsNegative(isNegative: Bool) {
        self.isNegative = isNegative
        adjustLeftView()
    }
    
    func setValue(value: NSDecimalNumber, isNegative: Bool) {
        setFieldText(value)
        setIsNegative(isNegative)
    }
    
    func getValue() -> NSDecimalNumber {
        return (textToNumber(textField?.text ?? "") ?? 0).decimalNumberByMultiplyingBy(isNegative ? -1 : 1)
    }
    
    func adjustLeftView() {
        leftView?.text = isNegative ? "-" : "+"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return textToNumber(text) != nil
    }

}
