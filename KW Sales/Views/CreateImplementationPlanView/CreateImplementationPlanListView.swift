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
    @State var implmentationPlanViews: [CreateInstallationView] = []
    @State var numSchools = 0
    
    var body: some View {
        Form {
            ForEach(0..<implmentationPlanViews.count, id: \.self) { imp in
                self.implmentationPlanViews[imp]
            }
            
            Button(action: {
                let viewModel = self.viewModel.addInstallation()
                self.implmentationPlanViews.append(CreateInstallationView(index: self.numSchools, viewModel: viewModel))
                self.numSchools += 1
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
    .navigationBarTitle("Implementation Plan")
    }
    
    
}

