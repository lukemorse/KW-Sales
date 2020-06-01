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
    @Binding var district: District
    @State var showSaveAlert = false
    
    var body: some View {
        Form {
            if self.district.implementationPlan.count > 0 {
                ForEach(0..<self.district.implementationPlan.count, id: \.self) { index in
                    InstallationView(viewModel: self.mainViewModel.getInstallationViewModels(for: self.district.districtName)[index])
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


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        ImplementationPlanView(district: .constant(District()))
    }
}
