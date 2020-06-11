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
    
    var body: some View {
        return Form {
            if district.implementationPlan.count > 0 {
                ForEach(0..<district.implementationPlan.count, id: \.self) { index in
                    InstallationView(installation: self.district.implementationPlan[index])
                }
            }
            
            Button(action: {
                let installation = Installation()
                self.district.implementationPlan.append(installation)
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


//struct CreateImplementationPlanListView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let mvm = MainViewModel()
//        var district = District()
//        district.districtID = "123"
//        mvm.districts = [district]
//
//        return
//            NavigationView {
//            ImplementationPlanView(districtId: "123").environmentObject(mvm)
//        }
//    .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
