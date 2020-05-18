//
//  ImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ImplementationPlanView: View {
    
    //    @ObservedObject var viewModel: ImplementationPlanViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    let districtName: String
    let districtIndex: Int
    
    var body: some View {
        Form {
            if mainViewModel.installationViewModels[self.districtName] != nil {
                ForEach(0..<self.mainViewModel.installationViewModels[self.districtName]!.count, id: \.self) { index in
                    InstallationView(index: index, viewModel: self.mainViewModel.installationViewModels[self.districtName]![index])
                    //                self.mainViewModel.implmentationPlanViews[index]
                }
            }
            
            
            Button(action: {
                self.mainViewModel.addInstallation(index: self.districtIndex)
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
            //        .onAppear() {
            //            if self.mainViewModel.installationViewModels.count > 0 {
            //                for view in self.mainViewModel.implmentationPlanViews {
            //                    view.isExpanded = false
            //                }
            //            }
            //        }
            .navigationBarTitle("Implementation Plan")
    }
}


//struct CreateImplementationPlanListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImplementationPlanView(viewModel: ImplementationPlanViewModel())
//    }
//}
