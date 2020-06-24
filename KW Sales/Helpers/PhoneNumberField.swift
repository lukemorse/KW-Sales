//
//  PhoneNumberField.swift
//  KW Sales
//
//  Created by Luke Morse on 6/4/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import UIKit
import AnyFormatKit

struct PhoneNumberField: View {
    @Binding var phoneNumber: String

    let phoneFormatter = DefaultTextFormatter(textPattern: "(###) ###-####")

    var body: some View {

    let phoneNumberProxy = Binding<String>(
        get: {
            return (self.phoneFormatter.format(self.phoneNumber) ?? "")
        },
        set: {
            self.phoneNumber = self.phoneFormatter.unformat($0) ?? ""
        }
    )

        return PhoneFieldContainer("Phone Number", text: phoneNumberProxy)
    }
}

struct PhoneNumberField_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberField(phoneNumber: .constant(""))
    }
}

/************************************************/

struct PhoneFieldContainer: UIViewRepresentable {
    private var placeholder : String
    private var text : Binding<String>

    init(_ placeholder:String, text:Binding<String>) {
        self.placeholder = placeholder
        self.text = text
    }

    func makeCoordinator() -> PhoneFieldContainer.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<PhoneFieldContainer>) -> UITextField {

        let innertTextField = UITextField(frame: .zero)
        innertTextField.placeholder = placeholder
        innertTextField.text = text.wrappedValue
        innertTextField.delegate = context.coordinator
        innertTextField.keyboardType = .numberPad
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: innertTextField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(innertTextField.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        innertTextField.inputAccessoryView = toolBar

        context.coordinator.setup(innertTextField)

        return innertTextField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PhoneFieldContainer>) {
        uiView.text = self.text.wrappedValue
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneFieldContainer

        init(_ phoneFieldContainer: PhoneFieldContainer) {
            self.parent = phoneFieldContainer
        }

        func setup(_ textField:UITextField) {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text.wrappedValue = textField.text ?? ""

            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             textField.resignFirstResponder()
            return true
        }
    }
}
