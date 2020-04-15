//
//  CreateImplementationPlanListView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CreateImplementationPlanListView: View {
    let installations: [Installation]
    @State private var selection: Set<Installation> = []
    var body: some View {
        scrollForEach
    }
    
    var scrollForEach: some View {
        ScrollView {
            ForEach(installations) { installation in
                CreateImplementationPlanView(isExpanded: self.selection.contains(installation), installation: installation)
                    .modifier(ListRowModifier())
                    .onTapGesture { self.selectDeselect(installation) }
                    .animation(.linear(duration: 0.3))
            }
        }
    }
    
    private func selectDeselect(_ installation: Installation) {
        if selection.contains(installation) {
            selection.remove(installation)
        } else {
            selection.insert(installation)
        }
    }
}

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
            Divider()
        }.offset(x: 20)
    }
}



struct CreateImplementationPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateImplementationPlanListView(installations: testInstallArray)
    }
}
