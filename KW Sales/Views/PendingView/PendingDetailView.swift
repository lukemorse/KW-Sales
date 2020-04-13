//
//  PendingDetailView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PendingDetailView: View {
    var name: String
    var body: some View {
        VStack {
            listView(list: groupSchoolsByStatusCode(list: testInstallArray))
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
        var status0Array: [Installation] = []
        var status1Array: [Installation] = []
        var status2Array: [Installation] = []
        for install in list {
            switch install.statusCode {
            case 0:
                status0Array.append(install)
            case 1:
                status1Array.append(install)
            case 2:
                status2Array.append(install)
            default:
                break
            }
        }
        return [status0Array,status1Array,status2Array]
    }
}

struct PendingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PendingDetailView(name: "testName")
    }
}
