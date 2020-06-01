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
    @ObservedObject private var keyboard = KeyboardResponder()
    let districtId: String
    @State var showSaveAlert = false
    
    var body: some View {
        let district = self.mainViewModel.getDistrict(id: districtId).wrappedValue
        return Form {
            if district.implementationPlan.count > 0 {
                ForEach(0..<district.implementationPlan.count, id: \.self) { index in
                    InstallationView().environmentObject(self.mainViewModel.getInstallationViewModels(for: district.districtName)[index])
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
        .padding(.bottom, keyboard.currentHeight)
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


//struct CreateImplementationPlanListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImplementationPlanView(district: .constant(District()))
//    }
//}
