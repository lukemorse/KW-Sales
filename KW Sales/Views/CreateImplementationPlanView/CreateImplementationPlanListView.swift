//
//  CreateImplementationPlanListView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CreateImplementationPlanListView: View {
    //    let installations: [Installation]
    @State var implmentationPlanViews: [CreateImplementationPlanView] = []
    @State var numSchools = 0
    
    var body: some View {
        Form {
            ForEach(0..<implmentationPlanViews.count, id: \.self) { imp in
                self.implmentationPlanViews[imp]
            }
            
            Button(action: {
                self.implmentationPlanViews.append(CreateImplementationPlanView(index: self.numSchools))
                self.numSchools += 1
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
        
        
    }
}


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateImplementationPlanListView()
    }
}
