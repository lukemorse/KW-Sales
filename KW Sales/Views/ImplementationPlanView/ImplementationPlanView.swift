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
    @Binding var district: District
    @State var childViews: [InstallationView] = []
    
    var body: some View {
        Form {
            if self.childViews.count > 0 {
                ForEach(0..<self.district.implementationPlan.count, id: \.self) { index in
                    self.childViews[index]
                }
            }
            
            Button(action: {
                self.district.implementationPlan.append(Installation())
                let index = self.district.implementationPlan.count - 1
                self.childViews.append(InstallationView(index: index, installation: self.$district.implementationPlan[index]))
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
        .onAppear() {
            if self.district.implementationPlan.count > 0 {
                for (index, _) in self.district.implementationPlan.enumerated() {
                    let view = InstallationView(index: index, installation: self.$district.implementationPlan[index])
                    self.childViews.append(view)
                }
            }
        }
        .navigationBarTitle("Implementation Plan")   
    }
}


//struct CreateImplementationPlanListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImplementationPlanView(viewModel: ImplementationPlanViewModel())
//    }
//}
