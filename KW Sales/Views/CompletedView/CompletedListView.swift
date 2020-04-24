//
//  CompletedView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedListView: View {
    var body: some View {
        VStack {
            listView(list: getCompleted(list: testInstallArray))
        }
    }
    
    func listView(list: [Installation]) -> some View {
        if list.count > 0 {
            return AnyView(
                List {
                    ForEach(0..<list.count, id: \.self) {index in
                        Text(list[index].schoolName)
                    }
                }
            )
        }
        
        return AnyView(List {
            Text("No Schools found")
        })
    }
    
    func getCompleted(list: [Installation]) -> [Installation] {
        var completedArray: [Installation] = []
        for install in list {
            if install.status == .complete {
                completedArray.append(install)
            }
        }
        return completedArray
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedListView()
    }
}
