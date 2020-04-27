//
//  CompletedDetailView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/27/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedDetailView: View {
    var district: District
    var body: some View {
        VStack {
            listView(list: fetchCompletedSchools(list: district.implementationPlan))
        }
    }
    
    func listView(list: [Installation]) -> some View {
        if list.count > 0 {
            
                return AnyView(List {
                    if list.count > 0 {
                        Section(header: Text("Completed")) {
                            ForEach(0..<list.count, id: \.self) {index in
                                Text(list[index].schoolName)
                                    .listRowBackground(Color.green)
                            }
                        }
                    }
                }
            )
        }
        
        return AnyView(List {
            Text("No Schools found")
        })
    }
    
    func fetchCompletedSchools(list: [Installation]) ->  [Installation] {
        
        var completeArray: [Installation] = []
        for install in list {
            if install.status == .complete {
                completeArray.append(install)
            }
        }
        return completeArray
    }
}
