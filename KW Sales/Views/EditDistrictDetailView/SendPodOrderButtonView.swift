//
//  SendPodOrderButtonView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MessageUI

struct SendPodOrderButtonView: View {
    var numPods: Int
    var email: String
    var textColor: Color
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isShowingAlert = false
    
    var body: some View {
        Button(action: {
            if self.email.isEmpty {
                self.isShowingAlert = true
                return
            }
            self.isShowingMailView.toggle()
        })
        {
            Text("Send Pod Order")
                .foregroundColor(self.textColor)
        }
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(numPods: self.numPods, email: self.email, result:  self.$mailResult)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: Text("Please enter valid email"))
        }
    }
}

struct SendPodOrderButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SendPodOrderButtonView(numPods: 5, email: "test@test.com", textColor: Color.red)
    }
}
