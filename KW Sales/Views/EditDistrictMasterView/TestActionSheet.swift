//
//  TestActionSheet.swift
//  KW Sales
//
//  Created by Luke Morse on 5/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import ActionOver

struct TestActionSheet: View {
    @State var showSheet = false
    var body: some View {
        Text("Hello")
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                self.showSheet = true
        }
        .navigationBarTitle(Text("Hello"))
        .navigationBarItems(leading: button)
            
        .actionOver(
            presented: $showSheet,
            title: "Hello",
            message: "Hello",
            buttons: [actionButton],
            ipadAndMacConfiguration: ipadMacConfig
        )
    }
    var button: some View {
        Button(action: {
            self.showSheet = true
        }) {
            Text("Show")
        }
    }
    
    var actionButton: ActionOverButton {
        ActionOverButton(title: "ButtonTitle", type: .normal) {
            print("tapped button")
        }
    }
    private var ipadMacConfig = {
        IpadAndMacConfiguration(anchor: nil, arrowEdge: nil)
    }()
}

struct TestActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TestActionSheet()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
