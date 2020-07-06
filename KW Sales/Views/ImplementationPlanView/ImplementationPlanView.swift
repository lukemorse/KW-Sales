//
//  ImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import CodableFirebase

struct ImplementationPlanView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var viewModel: ImplementationPlanViewModel
    @State var showSaveAlert = false
    let shouldAddStatusListeners: Bool
    
    init(viewModel: ImplementationPlanViewModel, shouldAddStatusListeners: Bool) {
        self.viewModel = viewModel
        self.shouldAddStatusListeners = shouldAddStatusListeners
    }
    
    var body: some View {
        return Form {
                ForEach(0..<viewModel.installations.count, id: \.self) { index in
                    InstallationView(viewModel: self.viewModel.installationViewModels[index], shouldAddStatusListeners: self.shouldAddStatusListeners)
                }
            
            Button(action: {
                self.viewModel.addInstallation()
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
        .enableKeyboardOffset()
        .navigationBarItems(trailing: saveButton)
        .navigationBarTitle("Implementation Plan")
        .alert(isPresented: self.$showSaveAlert) {
            Alert(title: Text("Saved Implementation Plan"))
        }
        .padding(.bottom, 10)
        .onAppear() {
            if self.viewModel.installations.count == 0 {
                self.viewModel.fetchInstallations()
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            self.viewModel.saveImplementationPlan { (success) in
                if success {
                    self.showSaveAlert = true
                }
            }
            print("save")
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
}



struct ImplementationPlanView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ImplementationPlanViewModel(districtID: "123")
        vm.installations = [Installation(districtID: "123")]
        return NavigationView {
            ImplementationPlanView(viewModel: vm, shouldAddStatusListeners: true).environmentObject(MainViewModel())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
