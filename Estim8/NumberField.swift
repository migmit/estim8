//
//  NumberOnlyText.swift
//  Estim8
//
//  Created by MigMit on 10/04/16.
//  Copyright © 2016 MigMit. All rights reserved.
//

import UIKit

protocol NumberFieldDelegate {
    func numberFieldDidBeginEditing(_ numberField: NumberField)
}

class NumberField: UITextField, UITextFieldDelegate {
    var initialUsesGroupingSeparator: Bool = false
    
    fileprivate var isNegative: Bool = false
    
    let numberFormatter: NumberFormatter = NumberFormatter()
    
    fileprivate var leftLabel: UILabel? = nil
    
    var numberDelegate: NumberFieldDelegate? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        numberFormatter.numberStyle = .decimal
        delegate = self
        let h = bounds.height
        let leftLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: h, height: h))
        leftLabel.textAlignment = .center
        leftView = leftLabel
        leftViewMode = .always
        self.leftLabel = leftLabel
        adjustLeftView()
        borderStyle = .roundedRect
        textAlignment = .left
        autocorrectionType = .no
        keyboardType = .decimalPad
    }
    
    func showSign(_ show: Bool) {
        self.leftViewMode = show ? .always : .never
    }
    
    func zeroRepresentation() -> String {
        return isEditing ? "" : "0"
    }
    
    func setFieldText(_ value: NSDecimalNumber) {
        switch value.compare(0) {
        case .orderedAscending:
            text = numberFormatter.string(from: value.multiplying(by: -1))
        case .orderedSame:
            text = zeroRepresentation()
        case .orderedDescending:
            text = numberFormatter.string(from: value)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let value = getValue()
        initialUsesGroupingSeparator = numberFormatter.usesGroupingSeparator
        numberFormatter.usesGroupingSeparator = false
        setFieldText(value)
        numberDelegate?.numberFieldDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = getValue()
        numberFormatter.usesGroupingSeparator = initialUsesGroupingSeparator
        setFieldText(value)
    }
    
    func textToNumber(_ from: String) -> NSDecimalNumber? {
        if (from.isEmpty) {
            return 0
        } else if let v = numberFormatter.number(from: from) {
            if (v.compare(0) != .orderedAscending) {
                return NSDecimalNumber(decimal: v.decimalValue)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setIsNegative(_ isNegative: Bool) {
        self.isNegative = isNegative
        adjustLeftView()
    }
    
    func setValue(_ value: NSDecimalNumber, isNegative: Bool) {
        setFieldText(value)
        setIsNegative(isNegative)
    }
    
    func getValue() -> NSDecimalNumber {
        return (textToNumber(text ?? "") ?? 0).multiplying(by: isNegative ? -1 : 1)
    }
    
    func adjustLeftView() {
        leftLabel?.text = isNegative ? "-" : "+"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        return textToNumber(text) != nil
    }
    
    
}
