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
            listView(dict: groupSchoolsByStatusCode(list: district.implementationPlan))
        }
    }
    
    func listView(dict: [InstallationStatus: [Installation]]) -> some View {
        if dict.count > 0 {
            return AnyView(
                List {
                    if dict[.complete]?.count ?? 0 > 0 {
                        Section(header: Text("Completed")) {
                            ForEach(0..<dict[.complete]!.count, id: \.self) {index in
                                Text(dict[.complete]![index].schoolName)
                                    .listRowBackground(Color.green)
                            }
                        }
                    }
                    
                    if dict[.inProgress]?.count ?? 0 > 0 {
                        Section(header: Text("In Progress")) {
                            ForEach(0..<dict[.inProgress]!.count, id: \.self) {index in
                                Text(dict[.inProgress]![index].schoolName)
                                    .listRowBackground(Color.yellow)
                            }
                        }
                    }
                    
                    if dict[.notStarted]?.count ?? 0 > 0 {
                        Section(header: Text("Not Started")) {
                            ForEach(0..<dict[.notStarted]!.count, id: \.self) {index in
                                Text(dict[.notStarted]![index].schoolName)
                                    .listRowBackground(Color.red)
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
    
    func groupSchoolsByStatusCode(list: [Installation]) -> [InstallationStatus: [Installation]] {
        
        var notStartedArray: [Installation] = []
        var inProgressArray: [Installation] = []
        var completeArray: [Installation] = []
        for install in list {
            switch install.status {
            case .complete:
                completeArray.append(install)
                
            case .inProgress:
                inProgressArray.append(install)
            case .notStarted:
                notStartedArray.append(install)
                
            }
        }
        return [.complete: completeArray,
                .inProgress: inProgressArray,
                .notStarted: notStartedArray]
    }
}

struct PendingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PendingDetailView(district: District())
    }
}
