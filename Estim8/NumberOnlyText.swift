//
//  NumberOnlyText.swift
//  Estim8
//
//  Created by MigMit on 10/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

protocol NumberFieldDelegate {
    func numberFieldDidBeginEditing(numberField: NumberField)
}

class NumberField: UITextField, UITextFieldDelegate {
    var initialUsesGroupingSeparator: Bool = false
    
    private var isNegative: Bool = false
    
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    private var leftLabel: UILabel? = nil
    
    var numberDelegate: NumberFieldDelegate? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        numberFormatter.numberStyle = .DecimalStyle
        delegate = self
        let h = bounds.height
        let leftLabel: UILabel = UILabel(frame: CGRectMake(0, 0, h, h))
        leftLabel.textAlignment = .Center
        leftView = leftLabel
        leftViewMode = .Always
        self.leftLabel = leftLabel
        adjustLeftView()
        borderStyle = .RoundedRect
        textAlignment = .Left
        autocorrectionType = .No
        keyboardType = .DecimalPad
    }
    
    func showSign(show: Bool) {
        self.leftViewMode = show ? .Always : .Never
    }
    
    func zeroRepresentation() -> String {
        return editing ? "" : "0"
    }
    
    func setFieldText(value: NSDecimalNumber) {
        switch value.compare(0) {
        case .OrderedAscending:
            text = numberFormatter.stringFromNumber(value.decimalNumberByMultiplyingBy(-1))
        case .OrderedSame:
            text = zeroRepresentation()
        case .OrderedDescending:
            text = numberFormatter.stringFromNumber(value)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let value = getValue()
        initialUsesGroupingSeparator = numberFormatter.usesGroupingSeparator
        numberFormatter.usesGroupingSeparator = false
        setFieldText(value)
        numberDelegate?.numberFieldDidBeginEditing(self)
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
        return (textToNumber(text ?? "") ?? 0).decimalNumberByMultiplyingBy(isNegative ? -1 : 1)
    }
    
    func adjustLeftView() {
        leftLabel?.text = isNegative ? "-" : "+"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return textToNumber(text) != nil
    }
    
    
}