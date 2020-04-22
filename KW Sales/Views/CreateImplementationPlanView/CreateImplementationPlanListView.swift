//
//  CreateImplementationPlanListView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CreateImplementationPlanListView: View {
    
//    @ObservedObject var viewModel = CreateImplementationPlanViewModel()
    @ObservedObject var viewModel: CreateImplementationPlanViewModel
    @State var implmentationPlanViews: [CreateImplementationPlanView] = []
    @State var numSchools = 0
    
    var body: some View {
        Form {
            ForEach(0..<implmentationPlanViews.count, id: \.self) { imp in
                self.implmentationPlanViews[imp]
            }
            
            Button(action: {
                self.implmentationPlanViews.append(CreateImplementationPlanView(index: self.numSchools, viewModel: self.viewModel))
                self.numSchools += 1
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
            Button(action: {
                self.uploadImplementationPlans()
            }) {
                Text("Finish")
                .foregroundColor(Color.blue)
            }
        }
    .navigationBarTitle("Implementation Plan")
    }
    
    func uploadImplementationPlans() -> [ImplementationPlanUnit] {
        var result: [ImplementationPlanUnit] = []
        for impView in implmentationPlanViews {
            let imp = impView.getImplementationPlanUnit()
            result.append(imp)
        }
        viewModel.uploadImplementationPlan(implemenationPlans: result)
        print(result)
        return result
    }
    
    
}

