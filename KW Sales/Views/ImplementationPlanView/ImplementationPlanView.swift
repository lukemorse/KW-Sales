//
//  ImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ImplementationPlanView: View {

    @EnvironmentObject var mainViewModel: MainViewModel
    @Binding var district: District
    
    var body: some View {
        Form {
            if self.district.implementationPlan.count > 0 {
                ForEach(0..<self.district.implementationPlan.count, id: \.self) { index in
                    InstallationView(index: index, viewModel: self.mainViewModel.installationViewModels[self.district.districtName]![index])
                }
            }
            
            Button(action: {
                self.district.implementationPlan.append(Installation())
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
        .navigationBarTitle("Implementation Plan")   
    }
}


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        ImplementationPlanView(district: .constant(District()))
    }
}
