//
//  HelperFunctions.swift
//  KW Sales
//
//  Created by Luke Morse on 4/17/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation

func validateEmail(enteredEmail:String) -> Bool {

    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)

}
