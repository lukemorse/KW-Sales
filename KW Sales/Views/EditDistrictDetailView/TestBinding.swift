//
//  TestBinding.swift
//  KW Sales
//
//  Created by Luke Morse on 4/22/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct Parent: View {
    var body: some View {
        VStack {
            self.testBinding
            Button(action: {
                print(self.testBinding.labelString)
                self.testBinding.getLabel()
            }) {
                Text("print")
            }
        }
        
    }
    var testBinding: Child {
        Child()
    }
}

struct Child: View {
    @State var labelString: String = ""
    
    var body: some View {
        TextField("label", text: $labelString)
            .padding()
    }
    
    func getLabel() {
        let statement = self.labelString
        print(statement)
    }
    
}

struct TestBinding_Previews: PreviewProvider {
    static var previews: some View {
        Parent()
    }
}
