//
//  LoginView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

//for testing
let correctUsername = "test"
let correctPassword = "123"

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLoginAlert = false
    
    var body: some View {
        VStack(spacing: 20.0) {
            Image("Logo")
                .resizable()
                .frame(width: 125, height: 100, alignment: .center)
            TextField("Enter email/username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            SecureField("Enter password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                self.attemptLogin()
                
            }) {
                Text("Submit")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .alert(isPresented: self.$showingLoginAlert) {
                Alert(title: Text("Hello"))
            }
        }
        .padding()
    
    }
    
    func attemptLogin() {
        print("attempt")
        if username == correctUsername && password == correctPassword {
            //login here
        } else {
//            alert
            showingLoginAlert = true
            username = ""
            password = ""
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().previewLayout(.fixed(width: 812, height: 375))
    }
}
