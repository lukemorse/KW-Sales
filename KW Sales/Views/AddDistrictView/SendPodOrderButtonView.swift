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
    @State var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        })
        {
            Text("Send Pod Order")
//                .font(.headline)
//                .padding(10.0)
//                .foregroundColor(Color.black)
//                .background(Color.blue)
//                .cornerRadius(10)
        }
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(numPods: self.numPods, email: self.email, result:  self.$mailResult)
        }
    }
}

struct SendPodOrderButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SendPodOrderButtonView(numPods: 5, email: "test@test.com")
    }
}
