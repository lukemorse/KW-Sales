//
//  CompletedView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedListView: View {
    @ObservedObject var viewModel = CompletedListViewModel()
    var body: some View {
        listView
            .onAppear() {
                self.viewModel.getDistrictsWithCompletedSchools()
        }
    }
    
    var listView : some View {
        if self.viewModel.districts.count > 0 {
            return AnyView(List {
                ForEach(0..<self.viewModel.districts.count, id: \.self) {index in
                    VStack {
                        NavigationLink(self.viewModel.districts[index].districtName , destination:
                            CompletedDetailView(district: self.viewModel.districts[index])
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

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedListView()
    }
}
