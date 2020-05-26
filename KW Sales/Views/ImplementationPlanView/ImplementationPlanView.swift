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
    @State var showSaveAlert = false
    let districtIndex: Int
    
    var body: some View {
        Form {
//            InstallationView(index: 0, viewModel: InstallationViewModel(installation: Installation()))
            if self.mainViewModel.districts[self.districtIndex].implementationPlan.count > 0 {
                ForEach(0..<self.mainViewModel.districts[self.districtIndex].implementationPlan.count, id: \.self) { index in
                    InstallationView(index: index, viewModel: self.mainViewModel.getInstallationViewModels(for: self.district.districtName)[index])
                }
            }
            
            Button(action: {
                self.mainViewModel.addInstallation(districtName: self.district.districtName)
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
        .navigationBarItems(trailing: saveButton)
        .navigationBarTitle("Implementation Plan")
        .alert(isPresented: self.$showSaveAlert) {
            Alert(title: Text("Saved Implementation Plan"))
        }
    }
    
    var saveButton: some View {
        Button(action: {
            self.showSaveAlert = true
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
}


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        ImplementationPlanView(district: .constant(District()), districtIndex: 0)
    }
}
