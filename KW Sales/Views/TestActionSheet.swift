//
//  TestActionSheet.swift
//  KW Sales
//
//  Created by Luke Morse on 4/16/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct TestActionSheet: View {
    @State private var isActionSheet = false

    var body: some View {
            Button(action: {
                self.isActionSheet = true
            }) {
                Text("ActionSheet")
                .foregroundColor(Color.white)
            }
            .padding()
            .background(Color.blue)
            .actionSheet(isPresented: $isActionSheet, content: {
                ActionSheet(title: Text("iOSDevCenters"), message: Text("SubTitle"), buttons: [
                    .default(Text("Save"), action: {
                        print("Save")
                    }),
                    .default(Text("Delete"), action: {
                        print("Delete")
                    }),
                    .destructive(Text("Cancel"))
                    ])
            }).onAppear() {
                print("on appear")
        }
    }
    }

struct TestActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        TestActionSheet()
    }
}
