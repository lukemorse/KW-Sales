//
//  StartView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/17/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

//testing
let correctUsername = "test"
let correctPassword = "1234"

struct StartView: View {
    @State private var isLoggedIn = false
    @State private var showingLoginAlert = false
    var body: some View {
        Group {
            isLoggedIn ? AnyView(MainView()) : AnyView(LoginView { (username, password, callBack: (Bool) -> Void) in
                let result = username == correctUsername && password == correctPassword
                self.setLoggedIn(newVal: result)
                if !result {
                    self.showingLoginAlert = true
                }
            })
        }
        .alert(isPresented: self.$showingLoginAlert) {
            Alert(title: Text("Incorrect username/password"))
        }
        
    }
    
    private func setLoggedIn(newVal: Bool) {
        self.isLoggedIn = newVal
    }
}
//
//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
