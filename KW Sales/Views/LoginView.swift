//
//  LoginView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import CodableFirebase

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLoginAlert = false
    @State private var isLoading = false
    
    init(logInHandler: @escaping (Bool, String?) -> ()) {
        self.viewModel = ViewModel(logInHandler: logInHandler)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20.0) {
                logo
                usernameField
                passwordField
                logInButton
            }
            if isLoading {
                ActivityIndicator()
            }
        }
    }
    
    var logo: some View {
        Image("Launch Image")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 300)
    }
    
    var usernameField: some View {
        TextField("Enter username", text: $username)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .textContentType(.oneTimeCode)
        .keyboardType(.emailAddress)
    }
    
    var passwordField: some View {
        SecureField("Enter password", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var logInButton: some View {
        Button(action: {
            self.isLoading = true
            self.viewModel.attemptLogIn(username: self.username, password: self.password)
        }) {
            Text("Submit")
                .fontWeight(.bold)
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
    }
    
    class ViewModel: ObservableObject {
        let logInHandler: (Bool, String?) -> Void
        
        init(logInHandler: @escaping (Bool, String?) -> Void) {
            self.logInHandler = logInHandler
        }
        
        func attemptLogIn(username: String, password: String) {
            let adjustedUsername = username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            Firestore.firestore().collection(Constants.kLogInDataCollection).whereField("username", isEqualTo: adjustedUsername).getDocuments { (snapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if let doc = snapshot!.documents.first {
                        do {
                            let doc = try FirestoreDecoder().decode([String:String].self, from: doc.data())
                            if doc["password"] == password {
                                self.logInHandler(true, adjustedUsername)
                            } else {
                                self.logInHandler(false, nil)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView {_,_ in }
    }
}
