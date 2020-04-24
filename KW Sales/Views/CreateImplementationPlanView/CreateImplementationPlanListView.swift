//
//  CreateImplementationPlanListView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CreateImplementationPlanListView: View {
    
    @ObservedObject var viewModel: ImplementationPlanListViewModel
    
    var body: some View {
        Form {
            ForEach(0..<self.viewModel.implmentationPlanViews.count, id: \.self) { index in
                self.viewModel.implmentationPlanViews[index]
            }
            
            Button(action: {
                self.viewModel.addInstallation()
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
            Button(action: {
                self.viewModel.uploadImplementationPlan()
            }) {
                Text("Finish")
                    .foregroundColor(Color.blue)
            }
        }
        .onAppear() {
            if self.viewModel.implmentationPlanViews.count > 0 {
                for view in self.viewModel.implmentationPlanViews {
                    view.isExpanded = false
                }
            }
        }
        .navigationBarTitle("Implementation Plan")
        
    }
    
}


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateImplementationPlanListView(viewModel: ImplementationPlanListViewModel())
    }
}
