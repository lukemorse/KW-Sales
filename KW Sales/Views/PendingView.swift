//
//  PendingView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

let testList = ["District 1", "District 2", "District 3"]

struct PendingView: View {
    var body: some View {
        listView
    }
    
    var listView : some View {
        if testList.count > 0 {
            return AnyView(List {
                ForEach(0..<testList.count, id: \.self) {index in
                    VStack {
                        NavigationLink(testList[index], destination:
                            Text(testList[index])
                        )
                    }
                }
            })
        }
        
        return AnyView(List {
            Text("No Schools found")
        })
    }
}
    
    struct PendingView_Previews: PreviewProvider {
        static var previews: some View {
            PendingView()
        }
}
