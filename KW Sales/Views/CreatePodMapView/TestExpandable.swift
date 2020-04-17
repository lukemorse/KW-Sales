//
//  TestExpandable.swift
//  KW Sales
//
//  Created by Luke Morse on 4/17/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct TestExpandable: View {
    @State var isOn = false
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $isOn) {
                    EmptyView().labelsHidden()
                }
            }
            Section {
                Text("hello").onTapGesture {
                    self.isOn.toggle()
                }
                if isOn {
                    Text("hi")
                    Text("hi")
                    Text("hi")
                    Text("hi")
                    Text("hi")
                }
            }
        }
    }
}

struct TestExpandable_Previews: PreviewProvider {
    static var previews: some View {
        TestExpandable()
    }
}
