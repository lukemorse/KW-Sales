//
//  AlertTest.swift
//  KW Sales
//
//  Created by Luke Morse on 6/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

//struct AlertItem: Identifiable {
//    var id = UUID()
//    var title: Text
//    var message: Text?
//    var dismissButton: Alert.Button?
//}

struct AlertTestView: View {

    @State private var alertItem: AlertItem?

    var body: some View {
        VStack {
            Button("First Alert") {
                self.alertItem = AlertItem(title: Text("First Alert"), message: Text("Message"))
            }
            Button("Second Alert") {
                self.alertItem = AlertItem(title: Text("Second Alert"), message: nil, dismissButton: .cancel(Text("Some Cancel")))
            }
            Button("Third Alert") {
                self.alertItem = AlertItem(title: Text("Third Alert"))
            }
        }
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

struct AlertTest_Previews: PreviewProvider {
    static var previews: some View {
        AlertTestView()
    }
}
