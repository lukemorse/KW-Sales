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
    
    var body: some View {
        Form {
            ForEach(0..<implmentationPlanViews.count, id: \.self) { imp in
           CreateImplementationPlanView(installation: testInstallArray[0])
            }
            
            Button(action: {
                self.implmentationPlanViews.append(CreateImplementationPlanView(installation: testInstallArray[0]))
            }) {
                Text("Add School")
            }
        }
        
        
    }
}


struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateImplementationPlanListView()
    }
}
