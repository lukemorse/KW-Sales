//
//  InstallationVMTest.swift
//  KW Sales
//
//  Created by Luke Morse on 5/18/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var string: String
    
    init(string: String) {
        self.string = string
    }
}

class ParentViewModel: ObservableObject {
    @Published var vmDict: [String: ViewModel] = [:]
}

struct Parent: View {
    var viewModel = ParentViewModel()
    var body: some View {
        if self.viewModel.vmDict.keys.contains("hi") {
            return Text(self.viewModel.vmDict["hi"]!.string)
        } else {
            return Text("")
        }
        
    }
}

struct InstallationVMTest_Previews: PreviewProvider {
    static var previews: some View {
        Parent()
    }
}
