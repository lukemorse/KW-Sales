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
    let districtId: String
    @State var showSaveAlert = false
    
    var body: some View {
        let district = self.mainViewModel.getDistrict(id: districtId).wrappedValue
        return Form {
            if district.implementationPlan.count > 0 {
                ForEach(0..<district.implementationPlan.count, id: \.self) { index in
                    InstallationView(viewModel: self.mainViewModel.getInstallationViewModels(for: district.districtName)[index])
                }
            }
            
            Button(action: {
                self.mainViewModel.addInstallation(districtName: self.mainViewModel.getDistrict(id: self.districtId).wrappedValue.districtName)
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
        .keyboardAdaptive()
        .padding(.bottom, 10)
    }
    
    var saveButton: some View {
        Button(action: {
            self.showSaveAlert = true
            print("save")
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
}


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mvm = MainViewModel()
        var district = District()
        district.districtID = "123"
        mvm.districts = [district]
        
        return
            NavigationView {
            ImplementationPlanView(districtId: "123").environmentObject(mvm)
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
}
