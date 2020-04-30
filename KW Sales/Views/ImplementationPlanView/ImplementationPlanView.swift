//
//  ImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ImplementationPlanView: View {
    
    @ObservedObject var viewModel: ImplementationPlanViewModel
    
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
        ImplementationPlanView(viewModel: ImplementationPlanViewModel())
    }
}
