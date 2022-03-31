//
//  LeftPaddedTextField.swift
//  Cocktails
//
//  Created by MacPro on 30.03.2022.
//

import UIKit

class LeftPaddedTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
    }
}
