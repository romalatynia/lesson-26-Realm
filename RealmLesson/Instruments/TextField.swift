//
//  TextField.swift
//  RealmLesson
//
//  Created by Roma Latynia on 4/13/21.
//

import UIKit

struct TextField {
    
    static func createField(
        withName: String?,
        and placeholder: String,
        tag: Int,
        delegade: UITextFieldDelegate? = nil
    ) -> UITextField {
        let field = UITextField()
        if let text = withName {
            field.text = text
        }
        field.placeholder = placeholder
        field.backgroundColor = UIColor.white
        field.borderStyle = .roundedRect
        field.delegate = delegade
        field.tag = tag
        return field
    }
    
    static func preferedKeyboard (textField: UITextField, keyboard: UIKeyboardType) {
        textField.keyboardType = keyboard
    }
}
