//
//  CustomTextField.swift
//  KW Sales
//
//  Created by Luke Morse on 6/24/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
//import UIKit
import SwiftUI

struct CustomTextfield: UIViewRepresentable {
    @Binding var text: String
    var keyType: UIKeyboardType
    var placeHolder: String
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
      textfield.keyboardType = keyType
        textfield.placeholder = placeHolder
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
