//
//  MockImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/21/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct MockImplementationPlanView: View {
    var body: some View {
        Form {
            InstallationView(index: 0, viewModel: InstallationViewModel(installation: Installation()))
        }
    }
}

struct MockImplementationPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MockImplementationPlanView()
    }
}
