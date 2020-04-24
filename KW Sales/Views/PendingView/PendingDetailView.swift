//
//  PendingDetailView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PendingDetailView: View {
    var district: District
    var body: some View {
        VStack {
            listView(list: groupSchoolsByStatusCode(list: district.implementationPlan))
        }
    }
    
    func listView(list: [[Installation]]) -> some View {
        if list.count > 0 {
            return AnyView(
                List {
                    Section(header: Text("Completed")) {
                        ForEach(0..<list[0].count, id: \.self) {index in
                            Text(list[0][index].schoolName)
                                .listRowBackground(Color.green)
                        }
                    }
                    Section(header: Text("In Progress")) {
                        ForEach(0..<list[1].count, id: \.self) {index in
                            Text(list[1][index].schoolName)
                                .listRowBackground(Color.yellow)
                        }
                    }
                    Section(header: Text("Not Started")) {
                        ForEach(0..<list[2].count, id: \.self) {index in
                            Text(list[2][index].schoolName)
                                .listRowBackground(Color.red)
                        }
                    }
                }   
            )
        }
        
        return AnyView(List {
            Text("No Schools found")
        })
    }
    
    func groupSchoolsByStatusCode(list: [Installation]) -> [[Installation]] {
        var notStartedArray: [Installation] = []
        var inProgressArray: [Installation] = []
        var completeArray: [Installation] = []
        for install in list {
            switch install.status {
            case .notStarted:
                notStartedArray.append(install)
            case .inProgress:
                inProgressArray.append(install)
            case .complete:
                completeArray.append(install)
            }
        }
        return [notStartedArray,inProgressArray,completeArray]
    }
}

struct PendingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PendingDetailView(district: District())
    }
}
