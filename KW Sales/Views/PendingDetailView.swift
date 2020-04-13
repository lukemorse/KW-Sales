//
//  PendingDetailView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

//test data
let completedSchools = ["Completed school 1", "Completed school 2", "Completed school 3"]
let inProgressSchools = ["In Progress school 1", "In Progress school 2", "In Progress school 3"]
let notStartedSchools = ["Not Started school 1", "Not Started school 2", "Not Started school 3"]

struct PendingDetailView: View {
    var body: some View {
        VStack {
            
        
        listView(list: completedSchools, backgroundColor: Color.green)
        listView(list: inProgressSchools, backgroundColor: Color.yellow)
        listView(list: notStartedSchools, backgroundColor: Color.red)
        }
    }
    
    func listView(list: [String], backgroundColor: Color) -> some View {
        if testList.count > 0 {
            return AnyView(List {
                ForEach(0..<list.count, id: \.self) {index in
                    Text(list[index])
                    .listRowBackground(backgroundColor)
                }
            })
        }
        
        return AnyView(List {
            Text("No Schools found")
        })
    }
}

struct PendingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PendingDetailView()
    }
}
